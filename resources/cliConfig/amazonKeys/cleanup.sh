cleanup_amazon_keys() {
  local aws_config_path=~/.aws
  if [ -d "$aws_config_path" ]; then
    rm -rf $aws_config_path
  fi
}

cleanup_amazon_keys_ecr() {
  local docker_config_path=~/.docker
  if [ -d "$docker_config_path" ]; then
    rm -rf $docker_config_path
  fi
}

trap before_exit EXIT
exec_grp "cleanup_amazon_keys" "Cleaning up configuration for <%= obj.dependency.name %>" "false"

<% if (obj.dependency.step && obj.dependency.step.scopes && _.contains(obj.dependency.step.scopes, 'ecr')) { %>
  trap before_exit EXIT
  exec_grp "cleanup_amazon_keys_ecr" "Cleaning up ECR configuration for <%= obj.dependency.name %>" "false"
<% } %>
