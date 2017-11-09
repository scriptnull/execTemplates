source <%= obj.jobInfoPath %>

kill_container() {
  exec_cmd "echo 'Killing container with ID $JOB_ID'"
  exec_cmd "docker stop $JOB_ID"
}

kill_process() {
  exec_cmd "echo 'Killing process with PID $JOB_ID'"
}

if [ $IS_CONTAINER == true ]; then
  trap before_exit EXIT
  exec_grp "kill_container" "Killing container"
else
  trap before_exit EXIT
  exec_grp "kill_process" "Killing process"
fi
