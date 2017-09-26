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

is_empty () {
  [ -z $1 ] || [ $1 == "null" ]
}

has_scope () {
  [[ $SCOPES =~ (^|,)$1(,|$) ]]
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
        ;;
    esac
  else
    print_help
    exit 1
  fi
}

check_and_set_vars () {
  AWS_ACCESS_KEY="$( shipctl get_integration_resource_field $RESOURCE_NAME "accessKey" )"
  AWS_SECRET_KEY="$( shipctl get_integration_resource_field $RESOURCE_NAME "secretKey" )"
  RESOURCE_VERSION_PATH="$(shipctl get_resource_meta $RESOURCE_NAME)/version.json"
  AWS_REGION="$( shipctl get_json_value $RESOURCE_VERSION_PATH "propertyBag.yml.pointer.region" )"

  if is_empty "$AWS_ACCESS_KEY"; then
    echo "Missing 'accessKey' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if is_empty "$AWS_SECRET_KEY"; then
    echo "Missing 'secretKey' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if is_empty "$AWS_REGION"; then
    echo "Missing 'region' value in pointer section of $RESOURCE_NAME's yml"
    exit 1
  fi
}

_configure_aws_cli () {
  aws configure set aws_access_key_id $AWS_ACCESS_KEY
  aws configure set aws_secret_access_key $AWS_SECRET_KEY
  aws configure set region $AWS_REGION

  echo "Successfully configured aws cli."
}

_configure_aws_ecr () {
  # TODO: complete aws ecr login script

  echo "Successfully configured aws ecr."
}

init() {
  echo "Setting up tools for $RESOURCE_NAME."
  if [ ! -z $SCOPES ]; then
    echo "Found scopes: $SCOPES"
  fi

  _configure_aws_cli

  if has_scope "ecr"; then
    _configure_aws_ecr
  fi
}

main() {
  parse_args "${ARGS[@]}"
  check_and_set_vars
  init
}

main
