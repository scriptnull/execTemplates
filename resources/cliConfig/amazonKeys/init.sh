init_amazon_keys_configure() {
  configure_access_key_output=$(aws configure set aws_access_key_id "<%= obj.dependency.accountIntegration.accessKey %>" 2>&1)
  ret=$?
  if [ "$ret" != 0 ]; then
    exec_cmd "echo 'Failed with error $configure_access_key_output'"
    return $ret
  fi

  configure_secret_key_output=$(aws configure set aws_secret_access_key "<%= obj.dependency.accountIntegration.secretKey %>" 2>&1)
  ret=$?
  if [ "$ret" != 0 ]; then
    exec_cmd "echo 'Failed with error $configure_secret_key_output'"
    return $ret
  fi

  configure_region_output=$(aws configure set region "<%= obj.dependency.propertyBag.yml.pointer.region %>" 2>&1)
  ret=$?
  if [ "$ret" != 0 ]; then
    exec_cmd "echo 'Failed with error $configure_region_output'"
    return $ret
  fi
}

init_amazon_keys_ecr() {
  configure_aws_ecr_output=$(aws ecr get-login --no-include-email 2>&1)
  ret=$?
  if [ "$ret" != 0 ]; then
    exec_cmd "echo 'Failed with error $configure_aws_ecr_output'"
    return $ret
  fi
}


trap before_exit EXIT
exec_grp "init_amazon_keys_configure" "Initializing <%= obj.dependency.name %>" "false"

<% if (obj.dependency.step && obj.dependency.step.scopes && _.contains(obj.dependency.step.scopes, 'ecr')) { %>
  trap before_exit EXIT
  exec_grp "init_amazon_keys_ecr" "Initializing <%= obj.dependency.name %> ECR" "false"
<% } %>
