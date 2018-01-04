function boot() {
    if ($env:TASK_CONTAINER_IMAGE_SHOULD_PULL -eq $TRUE) {
        exec_cmd "docker pull $env:TASK_CONTAINER_IMAGE"
    }

    exec_cmd "docker run $env:TASK_CONTAINER_OPTIONS $env:TASK_CONTAINER_IMAGE $env:TASK_CONTAINER_COMMAND"

    $global:is_success = $TRUE
    Write-Output "__SH__SCRIPT_END_SUCCESS__";
}

exec_grp "boot" "Booting up container for task: $env:TASK_NAME"

