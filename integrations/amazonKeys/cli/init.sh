#!/bin/bash -e
readonly IFS=$'\n\t'
readonly ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly SCRIPT_NAME="$( basename "$0" )"
readonly ARGS=("$@")

export RESOURCE_NAME=""
export SCOPES=""

print_help() {
  echo "
  Usage:
    $SCRIPT_NAME <resource_name> [scopes]
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
        SCOPES=$2
        if [ "$SCOPES" == "" ]; then
          SCOPES="configure"
        fi
        ;;
    esac
  else
    print_help
    exit 1
  fi
}

configure_aws_cli () {
  AWS_ACCESS_KEY="$( shipctl get_integration_resource_field $RESOURCE_NAME "accessKey" )"
  AWS_SECRET_KEY="$( shipctl get_integration_resource_field $RESOURCE_NAME "secretKey" )"

  RESOURCE_VERSION_PATH="$(shipctl get_resource_meta $RESOURCE_NAME)/version.json"
  AWS_REGION="$( shipctl get_json_value $RESOURCE_VERSION_PATH "propertyBag.yml.pointer.region" )"

  aws configure set aws_access_key_id $AWS_ACCESS_KEY
  aws configure set aws_secret_access_key $AWS_SECRET_KEY
  aws configure set region $AWS_REGION
}

init() {
  echo "Setting up $SCOPES for resource $RESOURCE_NAME."

  configure_aws_cli
}

main() {
  parse_args "${ARGS[@]}"
  init
}

main
