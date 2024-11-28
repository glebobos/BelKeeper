#!/usr/bin/env bash
set -e

usage() {
    cat <<EOF
Usage: $0 [-d] [-h]
  -d  Delete the stack
  -h  Display this help message
EOF
    exit 1
}

if [[ "$1" == "-h" ]]; then
    usage
fi

./CloudInit/tfStateInit.sh -f "./CloudInit/s3tfState.yaml" -e free -r eu-central-1 "$@"
