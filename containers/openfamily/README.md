# OpenFamily API image

`wheresfrank/openfamily` ships no container image for its Go API — the only
upstream artifact is the docker-compose stack, which builds `backend/Dockerfile`
on the host. Everything else in this repo deploys a published upstream image, so
this directory exists to make the one exception explicit and reviewable.

`.github/workflows/build-openfamily.yml` fetches the upstream repository at the
commit pinned in its `UPSTREAM_REF` env var, builds `backend/Dockerfile`
unmodified, and pushes `ghcr.io/blbecker/openfamily-api:sha-<short-sha>` (plus
`:latest`).

## Bumping

1. Review the upstream diff / release notes.
2. Update `UPSTREAM_REF` in `.github/workflows/build-openfamily.yml`.
3. Update the image tag in `flux/apps/openfamily/deployment.yml` to the new
   `sha-<short-sha>` (same commit, first 7 characters).
4. Merge to `main` — the push build publishes the image, then Flux rolls the
   Deployment.

## Notes

- The GHCR package must be **public**: Kyverno rewrites `ghcr.io/...` Deployment
  images to `harbor.tartarus.us/github_proxy/...`, and the pull-through proxy
  fetches anonymously (same as `ghcr.io/blbecker/hermes-agent`).
- The build needs the repository's `.git` (the Dockerfile resolves the deployed
  ref from it), which is why the workflow clones instead of downloading a
  tarball.
- API-only: the Android app is built and released by upstream (Flutter), and
  the admin panel downloads those release APKs at runtime.
