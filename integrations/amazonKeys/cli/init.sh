#!/bin/bash -e

# shellcheck source=integrations/common/envs.sh
source "$(dirname "$0")/../../common/envs.sh"
# shellcheck source=integrations/common/utils.sh
source "$(dirname "$0")/../../common/utils.sh"

RESOURCE_NAME=""
SCOPES=""
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
RESOURCE_VERSION_PATH=""
AWS_REGION=""

help() {
  echo "
  Usage:
    $SCRIPT_NAME <resource_name> [scopes]
  "
}

check_params() {
  RESOURCE_NAME=${ARGS[0]}
  SCOPES=${ARGS[1]}

  AWS_ACCESS_KEY="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "accessKey" )"
  AWS_SECRET_KEY="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "secretKey" )"
  RESOURCE_VERSION_PATH="$(shipctl get_resource_meta "$RESOURCE_NAME")/version.json"
  AWS_REGION="$( shipctl get_json_value "$RESOURCE_VERSION_PATH" "propertyBag.yml.pointer.region" )"

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

init_scope_configure() {
  aws configure set aws_access_key_id "$AWS_ACCESS_KEY"
  aws configure set aws_secret_access_key "$AWS_SECRET_KEY"
  aws configure set region "$AWS_REGION"
}

init_scope_ecr() {
  if is_docker_email_deprecated; then
    docker_login_cmd=$( aws ecr get-login --no-include-email )
  else
    docker_login_cmd=$( aws ecr get-login )
  fi

  echo "$docker_login_cmd" | bash
}

init() {
  check_params
  init_scope_configure
  if csv_has_value "$SCOPES" "ecr"; then
    init_scope_ecr
  fi
}

main() {
  if [[ "${#ARGS[@]}" -gt 0 ]]; then
    case "${ARGS[0]}" in
      --help)
        help
        exit 0
        ;;
      *)
        init
        ;;
    esac
  else
    help
    exit 1
  fi
}

main
