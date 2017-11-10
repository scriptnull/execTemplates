#
# Used to generate the boot script that brings up the task container
#

boot() {
  ret=0
  is_success=false
  <% var options = obj.options.replace(/\\/g, '\\\\') %>
  <% options = options.replace(/'/g, "\\'") %>
  <% var envs = obj.envs.replace(/\\/g, '\\\\') %>
  <% envs = envs.replace(/'/g, "\\'") %>
  <% var image = obj.image.replace(/\\/g, '\\\\') %>
  <% image = image.replace(/'/g, "\\'") %>
  <% var command = obj.command.replace(/\\/g, '\\\\') %>
  <% command = command.replace(/'/g, "\\'") %>

  exec_cmd $'sudo docker run <%= options %> <%= envs %> <%= image %> <%= command %>'
  ret=$?
  trap before_exit EXIT
  [ "$ret" != 0 ] && return $ret;

  is_success=true
}

trap before_exit EXIT
exec_grp "boot" "boot" "true"
