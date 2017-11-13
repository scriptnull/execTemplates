init_docker_registry_login_configure() {
  docker_registry_url="<%= obj.dependency.accountIntegration.url %>"
  docker_registry_username="<%= obj.dependency.accountIntegration.username %>"
  docker_registry_password="<%= obj.dependency.accountIntegration.password %>"
  docker_registry_email="<%= obj.dependency.accountIntegration.email %>"

  exec_cmd "echo 'Logging in to Docker'"

  if _is_docker_email_deprecated; then
    docker login -u $docker_registry_username -p $docker_registry_password $docker_registry_url
  else
    docker login -u $docker_registry_username -p $docker_registry_password -e $docker_registry_email $docker_registry_url
  fi
  ret=$?
  if [ "$ret" != 0 ]; then
    exec_cmd "echo 'Failed with error code $ret'"
    return $ret
  fi
}

trap before_exit EXIT
exec_grp "init_docker_registry_login_configure" "Initializing <%= obj.dependency.name %>" "false"
