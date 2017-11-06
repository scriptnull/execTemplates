#
# generating exec_cmd for each script in task section
#
boot() {
  ret=0
  is_success=false
  <% var options = obj.options.replace(/\\/g, '\\\\') %>
  <% options = options.replace(/'/g, "\\'") %>
  <% var envs = obj.envs.replace(/\\/g, '\\\\') %>
  <% envs = envs.replace(/'/g, "\\'") %>
  <% var volumes = obj.volumes.replace(/\\/g, '\\\\') %>
  <% volumes = volumes.replace(/'/g, "\\'") %>
  <% var image = obj.image.replace(/\\/g, '\\\\') %>
  <% image = image.replace(/'/g, "\\'") %>
  <% var command = obj.command.replace(/\\/g, '\\\\') %>
  <% command = command.replace(/'/g, "\\'") %>

  exec_cmd $'sudo docker run <%= options %> <%= envs %> <%= volumes %> <%= image %> <%= command %>'
  ret=$?
  trap before_exit EXIT
  [ "$ret" != 0 ] && return $ret;
  is_success=true
}

wait() {
  ret=0
  is_success=false
  exit_code=$(sudo docker wait <%= obj.containerName %> )
  exec_cmd "echo Container <%= obj.containerName %> exited with $exit_code"

  ret=$exit_code
  [ "$ret" != 0 ] && return $ret;
  is_success=true
}

trap before_exit EXIT
exec_grp "boot" "boot"

trap before_exit EXIT
exec_grp "wait" "wait"
