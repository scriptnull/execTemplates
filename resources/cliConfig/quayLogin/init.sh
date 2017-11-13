init_quay_login_configure() {
  quay_registry_username="<%= obj.dependency.accountIntegration.username %>"
  quay_registry_password="<%= obj.dependency.accountIntegration.password %>"
  quay_registry_email="<%= obj.dependency.accountIntegration.email %>"

  exec_cmd "echo 'Logging in to Quay'"

  if _is_docker_email_deprecated; then
    docker login -u $docker_registry_username -p $docker_registry_password quay.io
  else
    docker login -u $docker_registry_username -p $docker_registry_password -e $docker_registry_email quay.io
  fi
  ret=$?
  if [ "$ret" != 0 ]; then
    exec_cmd "echo 'Failed with error code $ret'"
    return $ret
  fi
}

trap before_exit EXIT
exec_grp "init_quay_login_configure" "Initializing <%= obj.dependency.name %>" "false"
