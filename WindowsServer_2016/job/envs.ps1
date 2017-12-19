#
# Used to generate the envs for the boot and task scripts
#

<% _.each(obj.commonEnvs, function (commonEnv) { %>
  $env:<%= commonEnv.key %> = "<%= commonEnv.value %>"
<% }); %>

<% _.each(obj.taskEnvs, function (taskEnv) { %>
  $env:<%= taskEnv.key %> = "<%= taskEnv.value %>"
<% }); %>

$env:SHIPPABLE_NODE_ARCHITECTURE = "<%= obj.shippableRuntimeEnvs.shippableNodeArchitecture %>"
$env:SHIPPABLE_NODE_OPERATING_SYSTEM = "<%= obj.shippableRuntimeEnvs.shippableNodeOperatingSystem %>"
$env:TASK_NAME = "<%= obj.shippableRuntimeEnvs.taskName %>"
$env:TASK_IN_CONTAINER = <%= obj.shippableRuntimeEnvs.isTaskInContainer ? "$TRUE" : "$FALSE" %>
