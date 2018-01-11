function boot() {
  if ($env:TASK_CONTAINER_IMAGE_SHOULD_PULL -eq $TRUE) {
    exec_cmd "docker pull $env:TASK_CONTAINER_IMAGE"
  }

  exec_cmd "docker run -d $env:TASK_CONTAINER_OPTIONS $env:TASK_CONTAINER_IMAGE $env:TASK_CONTAINER_COMMAND"
}

Function wait_for_exit() {
  $ret = Invoke-Expression "docker wait $env:TASK_CONTAINER_NAME"
  $msg = "Container $env:TASK_CONTAINER_NAME exited with exit code: $ret"
  exec_cmd "echo $msg"
  if ($ret -ne 0) {
    throw $msg
  }
}

Function before_exit() {
  if ($global:is_success) {
    Write-Output "__SH__SCRIPT_END_SUCCESS__"
  } else {
    Write-Output "__SH__SCRIPT_END_FAILURE__"
  }
}

Function main() {
  $global:is_success = $TRUE
  Try
  {
    exec_grp "boot" "Booting up container for task: $env:TASK_NAME"
    exec_grp "wait_for_exit" "Waiting for container: $env:TASK_CONTAINER_NAME to exit" $FALSE
  }
  Catch
  {
    $global:is_success = $FALSE
  }
  Finally
  {
    before_exit
  }
}

main
