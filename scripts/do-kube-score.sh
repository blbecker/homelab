#!/bin/bash

shopt -s globstar
shopt -s failglob
shopt -s extglob

set -u

REPO_ROOT=$(
    cd "$(dirname "${BASH_SOURCE[0]}")" || exit
    pwd -P
)/../

# Check if the directory exists
if [ ! -d "$REPO_ROOT" ]; then
    echo "Error: Directory '$REPO_ROOT' does not exist."
    exit 1
fi

# Variable to track if any kube-score invocation fails
error_occurred=false

# Score Apps
for dir in "${REPO_ROOT}"/flux/{apps,infra}/*; do
    echo -e "\nScoring ${dir}"

    # shellcheck disable=SC2086
    /kube-score score "${dir}"/**/*.yml "$@"
    if [ $? -ne 0 ]; then
        # If kube-score returns a non-zero status, set the error_occurred variable to true
        error_occurred=true
    fi
done

if $error_occurred; then
    exit 1
fi
