#!/bin/bash -e

readonly ROOT_DIR="$(dirname "$0")/../../.."
readonly COMMON_DIR="$ROOT_DIR/integrations/common"
readonly HELPERS_PATH="$COMMON_DIR/_helpers.sh"
readonly LOGGER_PATH="$COMMON_DIR/_logger.sh"

# shellcheck source=integrations/common/_helpers.sh
source "$HELPERS_PATH"
# shellcheck source=integrations/common/_logger.sh
source "$LOGGER_PATH"

export RESOURCE_NAME=""

help() {
  echo "
  Usage:
    $SCRIPT_NAME <resource_name> [scope]
  "
}

cleanup_scope_quay() {
  _log_msg "Cleaning up scope quay.io"

  local docker_config_path
  docker_config_path=~/.docker
  if [ -d "$docker_config_path" ]; then
    rm -rf $docker_config_path
  fi

  _log_success "Successfully cleaned up scope quay.io"
}

cleanup() {
  RESOURCE_NAME=${ARGS[0]}

  _log_grp "Cleaning up resource $RESOURCE_NAME"

  cleanup_scope_quay
}

main() {
  if [[ "${#ARGS[@]}" -gt 0 ]]; then
    case "${ARGS[0]}" in
      --help)
        help
        exit 0
        ;;
      *)
        cleanup
        ;;
    esac
  else
    help
    exit 1
  fi
}

main
