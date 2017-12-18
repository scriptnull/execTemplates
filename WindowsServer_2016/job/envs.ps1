$env:SHIPPABLE_NODE_ARCHITECTURE = "<%= obj.shippableRuntimeEnvs.shippableNodeArchitecture %>"
$env:SHIPPABLE_NODE_OPERATING_SYSTEM = "<%= obj.shippableRuntimeEnvs.shippableNodeOperatingSystem %>"
$env:TASK_NAME = "<%= obj.shippableRuntimeEnvs.taskName %>"
$env:TASK_IN_CONTAINER = <%= obj.shippableRuntimeEnvs.isTaskInContainer ? "$TRUE" : "$FALSE" %>
