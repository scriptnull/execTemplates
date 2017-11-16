#
# Used to generate the envs for the boot and task scripts
#

<% _.each(obj.commonEnvs, function (commonEnv) { %>
{
  export <%= commonEnv %>;
} || {
  exec_cmd "echo 'An error occurred while trying to export an environment variable: <%= commonEnv.split('=')[0] %> '"
  return 1
}
<% }); %>

<% _.each(obj.taskEnvs, function (taskEnv) { %>
{
  export <%= taskEnv %>;
} || {
  exec_cmd "echo 'An error occurred while trying to export an environment variable: <%= taskEnv.split('=')[0] %> '"
  return 1
}
<% }); %>

export SUBSCRIPTION_PRIVATE_KEY="$BUILD_DIR/secrets/00_sub"
export SHIPPABLE_NODE_OPERATING_SYSTEM="<%= obj.shippableRuntimeEnvs.SHIPPABLE_NODE_OPERATING_SYSTEM %>"
export TASK_NAME="<%= obj.shippableRuntimeEnvs.TASK_NAME %>"
export TASK_IN_CONTAINER=<%= obj.shippableRuntimeEnvs.TASK_IN_CONTAINER %>
if [ "$TASK_IN_CONTAINER" == true ]; then
  export TASK_CONTAINER_OPTIONS="<%= obj.shippableRuntimeEnvs.TASK_CONTAINER_OPTIONS %>"
  export TASK_CONTAINER_IMAGE="<%= obj.shippableRuntimeEnvs.TASK_CONTAINER_IMAGE %>"
  export TASK_CONTAINER_IMAGE_SHOULD_PULL="<%= obj.shippableRuntimeEnvs.TASK_CONTAINER_IMAGE_SHOULD_PULL %>"
  export TASK_CONTAINER_COMMAND="<%= obj.shippableRuntimeEnvs.TASK_CONTAINER_COMMAND %>"
fi
