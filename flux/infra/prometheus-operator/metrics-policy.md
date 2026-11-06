# Metrics curation policy

What we scrape, what we actually store, and how to tell the difference. The goal is bounded storage
without losing the ability to *discover* what a target exposes.

## The two independent things

1. **What a target exposes** — the scrape catalog. Prometheus records TYPE/HELP/UNIT metadata from the
   exposition text *before* `metric_relabel_configs` runs (see `scrape/scrape.go`: `EntryType`,
   `EntryHelp`, `EntryUnit` populate the scrape cache, while relabeling only happens later at
   `sl.sampleMutator(lset)`). So a family we drop from storage is still listed here:

   ```bash
   curl -s 'https://prometheus.tartarus.us/api/v1/targets/metadata?match_target={job="kubelet"}' \
     | jq -r '.[] | "\(.metric)\t\(.type)"' | sort -u
   ```

   Reverse lookup — which targets expose a given metric:

   ```bash
   curl -s 'https://prometheus.tartarus.us/api/v1/targets/metadata?metric=node_nfs_requests_total' | jq -r '.[].target.job' | sort -u
   ```

2. **What we store** — whatever survives the relabelings. `count by (__name__) ({__name__=~".+"})` is the
   persisted set; `/api/v1/metadata` is the same list with help text.

Because (1) is unaffected by (2), dropping aggressively is safe: a metric we never store is still
discoverable, and a *new* metric a dependency starts exposing shows up in the catalog even though it is
not being stored.

## Tier S1 — instrumentation plumbing (implemented)

Dropped at every scrape target that supports `metricRelabelings` (the kube-prometheus-stack components
via `helmrelease.yaml`, plus `service-monitors/longhorn.yml` and `pod-monitors/cloudnative-pg.yml`):

```
go_.*  process_*  workqueue_.*  rest_client_.*  scheduler_.*  kubernetes_feature_enabled
apiserver_watch_.*  *_body_size_bytes.*  apiserver_flowcontrol_.*  csi_operations_.*
storage_operation_.*  kubelet_runtime_operations_.*  volume_operation_total_seconds.*
longhorn_workqueue_.*  longhorn_rest_client_.*  node_scrape_collector_.*
node_network_{address_assign_type,device_id,flags,carrier*}  node_nfs_requests_total
node_boot_time_seconds  node_os_info  node_exporter_build_info
```

Measured on 2026-11-06, before the change: **337,385 series / ~11,000 samples/s / ~1.4–1.6 GB/day**.
S1 removes **140,643 series (42%)**, of which:

- `apiserver` −70,557 (46% of that job) — `apiserver_request_body_size_bytes_bucket` 19,328,
  `apiserver_watch_list_duration_seconds_bucket` 10,836, `apiserver_watch_cache_read_wait_seconds_bucket` 7,644
- `kubelet` −32,655 — `storage_operation_*` 5,866, `workqueue_*` 8,444, `kubelet_runtime_operations_*` 3,915,
  `scheduler_plugin_execution_*` 3,780, `kubernetes_feature_enabled` 3,388
- `longhorn-backend` −30,505 (85% of that job) — `longhorn_rest_client_*_latency_seconds_bucket` 13,904,
  `longhorn_workqueue_*` 9,922
- `node-exporter` −4,415 — `node_nfs_requests_total` 1,089 plus static `node_network_*` families

Nothing dropped here is referenced by any dashboard or rule in this repo (the dashboards and rules
reference 35 families / 1,916 series in total, and only the `traefik_*_duration_seconds_bucket`
histograms among them). `apiserver_request_total` and `apiserver_request_duration_seconds_bucket` are
deliberately kept — the `apiserver_request:*` recording rules and the upstream API-server dashboards
read them.

## Tier S2 — histograms nobody reads (not implemented)

55% of the remaining series are `_bucket` (183,978 of 337,385). Keeping only the histograms that are
actually queried — `apiserver_request_duration_seconds`, `traefik_*_duration_seconds`,
`prober_probe_duration_seconds` — removes another **160,554 series**, taking the TSDB to ~36k series
(~0.2 GB/day). That is the tier to reach for if 14d does not fit the volume.

## Tier S3 — trim kube-state-metrics at the source

`kube-state-metrics` exposes 250 families / 23,435 series. Restricting `--resources` to what we alert on
(pods, deployments, statefulsets, nodes, pv, pvc) drops ~6,600 series of `kube_replicaset_*`,
`kube_daemonset_*`, `kube_pod_tolerations` and friends, and makes the scrape cheaper too.

## Auditing: exposed vs persisted

```bash
# per job: how many families the target exposes, how many we store, how many we drop
for j in apiserver kubelet longhorn-backend kube-state-metrics node-exporter; do
  exposed=$(curl -s "https://prometheus.tartarus.us/api/v1/targets/metadata?match_target=%7Bjob%3D%22$j%22%7D&limit=200000" | jq -r '.[].metric' | sort -u | wc -l)
  stored=$(curl -s --data-urlencode "query=count by (__name__) ({job=\"$j\"})" https://prometheus.tartarus.us/api/v1/query | jq -r '.data.result | length')
  echo "$j exposed=$exposed stored=$stored"
done
```

Note the asymmetry: the catalog lists *family* names, while stored series include the derived
`_bucket`/`_sum`/`_count` names, so `stored` can exceed `exposed` for histogram-heavy jobs.

## Rules of thumb

- **Never drop a family an alert or dashboard reads.** Grep `rules/` and `files/dashboards/` first; the
  audit above tells you the cost of keeping it.
- **Prefer dropping whole families over dropping labels.** `labeldrop` on a high-cardinality label
  (`container_id`, `image`, `id`) collapses series and is the bigger win when a family must stay.
- **Scrape interval is a multiplier.** Halving a job's interval halves its storage; control-plane jobs
  do not need 30s.
- **`sampleLimit`** on a target bounds the damage from an accidental cardinality explosion.
- **Retention is two knobs.** `retention` (time) and `retentionSize` (bytes) — whichever trips first
  wins. When the size limit wins, the time window silently shrinks; that is what
  `PrometheusRetentionSizeBound` and the "Prometheus storage & compaction" dashboard exist to show.
