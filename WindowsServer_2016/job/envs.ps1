$SHIPPABLE_NODE_ARCHITECTURE = "<%= obj.shippableRuntimeEnvs.shippableNodeArchitecture %>"
$SHIPPABLE_NODE_OPERATING_SYSTEM = "<%= obj.shippableRuntimeEnvs.shippableNodeOperatingSystem %>"
$TASK_NAME = "<%= obj.shippableRuntimeEnvs.taskName %>"
$TASK_IN_CONTAINER = <%= obj.shippableRuntimeEnvs.isTaskInContainer ? "$TRUE" : "$FALSE" %>
