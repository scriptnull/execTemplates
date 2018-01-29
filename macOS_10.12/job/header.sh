#!/bin/bash -e

#
# Header script is attached at the beginning of every script generated and
# contains the most common methods use across the script
#

before_exit() {
  return_code=$?
  exit_code=1;
  if [ -z "$is_success" ]; then
    if [ $return_code -eq 0 ]; then
      is_success=true
      exit_code=0
    fi
  fi

  # Flush any remaining console
  echo $1
  echo $2

  if [ -n "$current_cmd_uuid" ]; then
    current_timestamp=`date +"%s"`
    echo "__SH__CMD__END__|{\"type\":\"cmd\",\"sequenceNumber\":\"$current_timestamp\",\"id\":\"$current_cmd_uuid\",\"exitcode\":\"$exit_code\"}|$current_cmd"
  fi

  if [ -n "$current_grp_uuid" ]; then
    current_timestamp=`date +"%s"`
    echo "__SH__GROUP__END__|{\"type\":\"grp\",\"sequenceNumber\":\"$current_timestamp\",\"id\":\"$current_grp_uuid\",\"is_shown\":\"false\",\"exitcode\":\"$exit_code\"}|$current_grp"
  fi

  if [ "$is_success" == true ]; then
    # "on_success" is only defined for the last task, so execute "always" only
    # if this is the last task.
    if [ "$(type -t on_success)" == "function" ]; then
      exec_cmd "on_success" || true

      if [ "$(type -t always)" == "function" ]; then
        exec_cmd "always" || true
      fi
    fi

    echo "__SH__SCRIPT_END_SUCCESS__";
  else
    if [ "$(type -t on_failure)" == "function" ]; then
      exec_cmd "on_failure" || true
    fi

    if [ "$(type -t always)" == "function" ]; then
      exec_cmd "always" || true
    fi

    echo "__SH__SCRIPT_END_FAILURE__";
  fi
}

on_error() {
  exit $?
}

exec_cmd() {
  cmd="$@"
  cmd_uuid=$(uuidgen | awk '{print tolower($0)}')
  cmd_start_timestamp=`date +"%s"`
  echo "__SH__CMD__START__|{\"type\":\"cmd\",\"sequenceNumber\":\"$cmd_start_timestamp\",\"id\":\"$cmd_uuid\"}|$cmd"

  export current_cmd=$cmd
  export current_cmd_uuid=$cmd_uuid

  trap on_error ERR

  eval "$cmd"
  cmd_status=$?

  unset current_cmd
  unset current_cmd_uuid

  if [ "$2" ]; then
    echo $2;
  fi

  cmd_end_timestamp=`date +"%s"`
  # If cmd output has no newline at end, marker parsing
  # would break. Hence force a newline before the marker.
  echo ""
  echo "__SH__CMD__END__|{\"type\":\"cmd\",\"sequenceNumber\":\"$cmd_start_timestamp\",\"id\":\"$cmd_uuid\",\"exitcode\":\"$cmd_status\"}|$cmd"
  return $cmd_status
}

exec_grp() {
  # First argument is function to execute
  # Second argument is function description to be shown
  # Third argument is whether the group should be shown or not
  group_name=$1
  group_message=$2
  is_shown=true
  if [ ! -z "$3" ]; then
    is_shown=$3
  fi

  if [ -z "$group_message" ]; then
    group_message=$group_name
  fi
  group_uuid=$(uuidgen | awk '{print tolower($0)}')
  group_start_timestamp=`date +"%s"`
  echo ""
  echo "__SH__GROUP__START__|{\"type\":\"grp\",\"sequenceNumber\":\"$group_start_timestamp\",\"id\":\"$group_uuid\",\"is_shown\":\"$is_shown\"}|$group_message"
  group_status=0

  export current_grp=$group_message
  export current_grp_uuid=$group_uuid

  {
    eval "$group_name"
  } || {
    group_status=1
  }

  unset current_grp
  unset current_grp_uuid

  group_end_timestamp=`date +"%s"`
  echo "__SH__GROUP__END__|{\"type\":\"grp\",\"sequenceNumber\":\"$group_end_timestamp\",\"id\":\"$group_uuid\",\"is_shown\":\"$is_shown\",\"exitcode\":\"$group_status\"}|$group_message"
  return $group_status
}
