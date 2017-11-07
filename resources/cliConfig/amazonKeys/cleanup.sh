cleanup_amazon_keys() {
  if [ -d "~/.aws" ]; then
    rm -rf $aws_config_path
  fi
}

cleanup_amazon_keys_ecr() {
  if [ -d "~/.docker" ]; then
    rm -rf $docker_config_path
  fi
}

trap before_exit EXIT
exec_grp "cleanup_amazon_keys" "Cleaning up configuration for <%= obj.dependency.name %>" "false"

<% if (obj.dependency.step && obj.dependency.step.scopes && _.contains(obj.dependency.step.scopes, 'ecr')) { %>
  trap before_exit EXIT
  exec_grp "cleanup_amazon_keys_ecr" "Cleaning up ECR configuration for <%= obj.dependency.name %>" "false"
<% } %>
