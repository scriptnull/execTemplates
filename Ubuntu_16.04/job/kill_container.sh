#
# Used to stop the container when the job is cancelled/timed-out
#

kill_container() {
  sudo docker stop -t=0 $TASK_CONTAINER_NAME
}

exec_grp "kill_container" "Stopping container $TASK_CONTAINER_NAME" false
