#!/usr/bin/env bash
set -euo pipefail

# Project base = one level up from this script’s directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ROOT="${1:-$PROJECT_ROOT/terraform}"
PLANS_DIR="${2:-$PROJECT_ROOT/plans}"
manifest="$PLANS_DIR/manifest.tsv"

export TF_IN_AUTOMATION=1

[ -s "$manifest" ] || {
  echo "no manifest; nothing to apply"
  exit 0
}

# Note: order is manifest order; Terragrunt dependency graph is not enforced here.

while IFS=$'\t' read -r rel plan_path; do
  [ -n "$rel" ] || continue
  [ -f "$plan_path" ] || {
    echo "missing plan: $plan_path" >&2
    exit 1
  }

  dir="$ROOT/$rel"
  echo "apply: $rel"
  dotenvx run -- terragrunt --working-dir "$dir" apply -input=false -no-color "${PROJECT_ROOT}/$plan_path"
done <"$manifest"
