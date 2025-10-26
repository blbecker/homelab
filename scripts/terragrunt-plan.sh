#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-./terraform}"  # terragrunt --working-dir
PLANS_DIR="${2:-./plans}" # artifact dir
rm -rf ${PLANS_DIR}/*
mkdir -p "$PLANS_DIR"

export TF_IN_AUTOMATION=1

manifest="$PLANS_DIR/manifest.tsv"
: >"$manifest"

changed=0

# Null-delimited search for terragrunt.hcl
while IFS= read -r -d '' tg; do
  dir="$(dirname "$tg")"

  # Skip aggregator dirs that don't define a terraform block
  if ! grep -q '^\s*terraform\s*{' "$tg"; then
    echo "skip: $dir (no terraform block)"
    continue
  fi

  # Relpath for stable artifact names
  rel="${dir#${ROOT%/}/}"
  rel="${rel#./}" # tidy
  safe_name="$(printf '%s' "$rel" | sed 's#[/ ]#__#g')"
  plan_path="$PLANS_DIR/${safe_name}.tfplan"

  echo "plan: $rel"
  set +e
  dotenvx run -- terragrunt --working-dir "$dir" plan -out=tfplan -input=false -no-color -detailed-exitcode
  rc=$?
  set -e

  case "$rc" in
  0)
    # No changes -> discard any tfplan created by Terraform
    [ -f "$dir/tfplan" ] && rm -f "$dir/tfplan"
    ;;
  2)
    changed=1
    cp "$dir/tfplan" "$plan_path"
    rm -f "$dir/tfplan"
    printf '%s\t%s\n' "$rel" "$plan_path" >>"$manifest"
    ;;
  *)
    echo "error: plan failed in $rel (exit $rc)" >&2
    exit "$rc"
    ;;
  esac
done < <(find "$ROOT" -type f -name 'terragrunt.hcl' -not -path '*/.terragrunt-cache/*' -print0 | sort -z)

if [ "$changed" -eq 1 ]; then
  echo "changes: yes"
else
  echo "changes: no"
fi

# Optional CI-friendly flag file
echo "$changed" >"$PLANS_DIR/changed.flag"
