cleanup_quay_login() {
  local docker_config_path=~/.docker
  if [ -d "$docker_config_path" ]; then
    rm -rf $docker_config_path
  fi
}

trap before_exit EXIT
exec_grp "cleanup_quay_login" "Cleaning up configuration for <%= obj.dependency.name %>" "false"
