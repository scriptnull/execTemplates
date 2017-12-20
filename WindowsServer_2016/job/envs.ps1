#
# Used to generate the envs for the boot and task scripts
#

<% _.each(obj.commonEnvs, function (commonEnv) { %>
  Try
  {
    $env:<%= commonEnv.key %> = "<%= commonEnv.value %>"
  }
  Catch
  {
    exec_cmd "Write-Output 'An error occurred while trying to export an environment variable: <%= commonEnv.key %> '"
  }
<% }); %>

<% _.each(obj.taskEnvs, function (taskEnv) { %>
  Try
  {
    $env:<%= taskEnv.key %> = "<%= taskEnv.value %>"
  }
  Catch
  {
    exec_cmd "Write-Output 'An error occurred while trying to export an environment variable: <%= taskEnv.key %> '"
  }
<% }); %>

$env:SHIPPABLE_NODE_ARCHITECTURE = "<%= obj.shippableRuntimeEnvs.shippableNodeArchitecture %>"
$env:SHIPPABLE_NODE_OPERATING_SYSTEM = "<%= obj.shippableRuntimeEnvs.shippableNodeOperatingSystem %>"
$env:TASK_NAME = "<%= obj.shippableRuntimeEnvs.taskName %>"
$env:TASK_IN_CONTAINER = <%= obj.shippableRuntimeEnvs.isTaskInContainer ? "$TRUE" : "$FALSE" %>
