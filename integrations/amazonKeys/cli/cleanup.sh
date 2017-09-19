#!/bin/bash -e
readonly IFS=$'\n\t'
readonly ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly SCRIPT_NAME="$( basename "$0" )"
readonly ARGS=("$@")

export RESOURCE_NAME=""
export SCOPE=""

print_help() {
  echo "
  Usage:
    $SCRIPT_NAME <resource_name> [scope]
  "
}

parse_args() {
  if [ "$#" -gt 0 ]; then
    key="$1"
    case "$key" in
      --help)
        print_help
        exit 0
        ;;
      *)
        RESOURCE_NAME=$1
        SCOPE=$2
        if [ "$SCOPE" == "" ]; then
          SCOPE="configure"
        fi
        ;;
    esac
  else
    print_help
    exit 1
  fi
}

cleanup() {
  echo "Cleaning up resource $RESOURCE_NAME for scope $SCOPE."
}

main() {
  parse_args "${ARGS[@]}"
  cleanup
}

main
