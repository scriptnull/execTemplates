#
# Used to generate the envs for the boot and task scripts
#

<% _.each(obj.commonEnvs, function (commonEnv) { %>
  try {
    $env:<%= commonEnv.key %> = "<%= commonEnv.value %>"
  } catch {
    exec_cmd "Write-Error 'An error occurred while trying to export an environment variable: <%= commonEnv.key %> '"
  }
<% }); %>

<% _.each(obj.taskEnvs, function (taskEnv) { %>
  try {
    $env:<%= taskEnv.key %> = "<%= taskEnv.value %>"
  } catch {
    exec_cmd "Write-Error 'An error occurred while trying to export an environment variable: <%= taskEnv.key %> '"
  }
<% }); %>

$env:SHIPPABLE_NODE_ARCHITECTURE = "<%= obj.shippableRuntimeEnvs.shippableNodeArchitecture %>"
$env:SHIPPABLE_NODE_OPERATING_SYSTEM = "<%= obj.shippableRuntimeEnvs.shippableNodeOperatingSystem %>"
$env:TASK_NAME = "<%= obj.shippableRuntimeEnvs.taskName %>"
$env:TASK_IN_CONTAINER = <%= obj.shippableRuntimeEnvs.isTaskInContainer ? "$TRUE" : "$FALSE" %>
