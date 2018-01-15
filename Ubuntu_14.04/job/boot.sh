#
# Used to generate the boot script that brings up the task container
#

boot() {
  ret=0
  is_success=false

  if [ "$TASK_CONTAINER_IMAGE_SHOULD_PULL" == true ]; then
    exec_cmd "sudo docker pull $TASK_CONTAINER_IMAGE"
  fi

  exec_cmd "sudo docker run $TASK_CONTAINER_OPTIONS $TASK_CONTAINER_IMAGE $TASK_CONTAINER_COMMAND"
  ret=$?
  trap before_exit EXIT
  [ "$ret" != 0 ] && return $ret;

  is_success=true
}

wait_for_exit() {
  ret=0
  is_success=false

  ret=$(sudo docker wait $TASK_CONTAINER_NAME)
  exec_cmd "echo Container $TASK_CONTAINER_NAME exited with exit code: $ret"
  sudo docker rm -fv $TASK_CONTAINER_NAME || true

  trap before_exit EXIT
  [ "$ret" != 0 ] && return $ret;

  is_success=true
}

trap before_exit EXIT
exec_grp "boot" "Booting up container for task: $TASK_NAME" "true"

trap before_exit EXIT
exec_grp "wait_for_exit" "Waiting for container:$TASK_CONTAINER_NAME to exit" "false"
