#
# Used to generate the boot script that brings up the task container or process
#

# TODO: Consider replacing this with an ENV IS_CONTAINER when it's available.
# The function names might have to change to accomodate this.
<% if (obj.isContainer) { %>
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

<% } else { %>
boot() {
  exec_cmd "echo Dummy boot for host"
}

wait() {
  exec_cmd "echo Dummy wait for host"
}
<% } %>

trap before_exit EXIT
exec_grp "boot" "boot" "false"

trap before_exit EXIT
exec_grp "wait" "wait" "false"
