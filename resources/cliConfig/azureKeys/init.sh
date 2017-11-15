#!/bin/bash -e

readonly ROOT_DIR="$(dirname "$0")/../../.."
readonly COMMON_DIR="$ROOT_DIR/resources/common"
readonly HELPERS_PATH="$COMMON_DIR/_helpers.sh"
readonly LOGGER_PATH="$COMMON_DIR/_logger.sh"

# shellcheck source=resources/common/_helpers.sh
source "$HELPERS_PATH"
# shellcheck source=resources/common/_logger.sh
source "$LOGGER_PATH"

export AZUREKEYS_APPID=""
export AZUREKEYS_PASSWORD=""
export AZUREKEYS_TENANT=""

help() {
  echo "
  Usage:
    $SCRIPT_NAME <resource_name> [scopes]
  "
}

check_params() {
  _log_msg "Checking params"

  AZUREKEYS_APPID="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "appId" )"
  AZUREKEYS_PASSWORD="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "password" )"
  AZUREKEYS_TENANT="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "tenant" )"

  if _is_empty "$AZUREKEYS_APPID"; then
    _log_err "Missing 'appId' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if _is_empty "$AZUREKEYS_PASSWORD"; then
    _log_err "Missing 'password' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if _is_empty "$AZUREKEYS_TENANT"; then
    _log_err "Missing 'tenant' value in pointer section of $RESOURCE_NAME's yml"
    exit 1
  fi

  _log_success "Successfully checked params"
}

init_scope_configure() {
  _log_msg "Initializing scope configure"

  az login --service-principal -u "$AZUREKEYS_APPID" --password "$AZUREKEYS_PASSWORD" --tenant "$AZUREKEYS_TENANT"

  _log_success "Successfully initialized scope configure"
}

init() {
  RESOURCE_NAME=${ARGS[0]}

  _log_grp "Initializing azureKeys for resource $RESOURCE_NAME"

  check_params
  init_scope_configure
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
