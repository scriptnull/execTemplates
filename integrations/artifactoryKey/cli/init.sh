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
export SCOPES=""
export JFROG_USERNAME=""
export JFROG_PASSWORD=""
export JFROG_URL=""

help() {
  echo "
  Usage:
    $SCRIPT_NAME <resource_name> [scopes]
  "
}

check_params() {
  _log_msg "Checking params"

  JFROG_USERNAME="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "userName" )"
  JFROG_PASSWORD="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "password" )"
  JFROG_URL="$( shipctl get_integration_resource_field "$RESOURCE_NAME" "url" )"

  if _is_empty "$JFROG_USERNAME"; then
    _log_err "Missing 'userName' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if _is_empty "$JFROG_PASSWORD"; then
    _log_err "Missing 'password' value in $RESOURCE_NAME's integration."
    exit 1
  fi

  if _is_empty "$JFROG_URL"; then
    _log_err "Missing 'url' value in pointer section of $RESOURCE_NAME's yml"
    exit 1
  fi

  _log_success "Successfully checked params"
}

init_scope_configure() {
  _log_msg "Initializing scope configure"

  jfrog_version=$(jfrog --version | awk '{print $3}' )
  jfrog_MajorVersion=$(echo $jfrog_version | awk -F '.' '{print $1}' )
  jfrog_MinorVersion=$(echo $jfrog_version | awk -F '.' '{print $2}' )

  newJFrogCommand="jfrog rt config default-server --url $JFROG_URL \
  --password $JFROG_PASSWORD --user $JFROG_USERNAME \
  --interactive=false && jfrog rt use default-server"

  oldJFrogCommand="jfrog rt config --url $JFROG_URL --password \
  $JFROG_PASSWORD --user $JFROG_USERNAME"

  if [ "$jfrog_MajorVersion" -gt "1" ] ||
    ( [ "$jfrog_MajorVersion" -eq "1" ] &&
    [ "$jfrog_MinorVersion" -gt "9" ] ); then $newJFrogCommand;
  else $oldJFrogCommand;
  fi;

  _log_success "Successfully initialized scope configure"
}

init() {
  RESOURCE_NAME=${ARGS[0]}
  SCOPES=${ARGS[1]}

  _log_grp "Initializing artifactoryKey for resource $RESOURCE_NAME"
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
