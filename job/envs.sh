#
# Used to generate the envs for the boot and task scripts
#

<% _.each(obj.envs, function (env) { %>
{
  export <%= env %>;
} || {
  exec_cmd "echo 'An error occurred while trying to export an environment variable: <%= env.split('=')[0] %> '"
  return 1
}
<% }); %>

export SUBSCRIPTION_PRIVATE_KEY="$BUILD_DIR/secrets/00_sub"
