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

export SHIPPABLE_NODE_ARCHITECTURE="<%= obj.shippableRuntimeEnvs.shippableNodeArchitecture %>"
export SHIPPABLE_NODE_OPERATING_SYSTEM="<%= obj.shippableRuntimeEnvs.shippableNodeOperatingSystem %>"
export TASK_NAME="<%= obj.shippableRuntimeEnvs.taskName %>"
export TASK_IN_CONTAINER=<%= obj.shippableRuntimeEnvs.isTaskInContainer %>
if [ "$TASK_IN_CONTAINER" == true ]; then
  export TASK_CONTAINER_OPTIONS="<%= obj.shippableRuntimeEnvs.taskContainerOptions %>"
  export TASK_CONTAINER_IMAGE="<%= obj.shippableRuntimeEnvs.taskContainerImage %>"
  export TASK_CONTAINER_IMAGE_SHOULD_PULL="<%= obj.shippableRuntimeEnvs.shouldPullTaskContainerImage %>"
  export TASK_CONTAINER_COMMAND="<%= obj.shippableRuntimeEnvs.taskContainerCommand %>"
fi
