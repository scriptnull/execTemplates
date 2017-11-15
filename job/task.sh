#
# The script to run the user provided commands is generated here
#
export SUBSCRIPTION_PRIVATE_KEY="$BUILD_DIR/secrets/00_sub"

# Adding this to support build directory expected with genExec
symlink_build_dir() {
  ln -s $BUILD_DIR /build
}

add_subscription_ssh_key() {
  exec_cmd "eval `ssh-agent -s`"
  # TODO: remove || true, after making ssh-add work on host runSh jobs
  exec_cmd "ssh-add $SUBSCRIPTION_PRIVATE_KEY || true"
}

<% if (obj.onSuccess) { %>
on_success() {
  # : to allow empty section
  :
  <% _.each(obj.onSuccess.script, function(cmd) { %>
    <% var cmdEscaped = cmd.replace(/\\/g, '\\\\')%>
    <% cmdEscaped = cmdEscaped.replace(/'/g, "\\'") %>
    eval $'<%= cmdEscaped %>'
  <% }); %>
}
<% } %>

<% if (obj.onFailure) { %>
on_failure() {
  # : to allow empty section
  :
  <% _.each(obj.onFailure.script, function(cmd) { %>
    <% var cmdEscaped = cmd.replace(/\\/g, '\\\\')%>
    <% cmdEscaped = cmdEscaped.replace(/'/g, "\\'") %>
    eval $'<%= cmdEscaped %>'
  <% }); %>
}
<% } %>

<% if (obj.always) { %>
always() {
  # : to allow empty section
  :
  <% _.each(obj.always.script, function(cmd) { %>
    <% var cmdEscaped = cmd.replace(/\\/g, '\\\\')%>
    <% cmdEscaped = cmdEscaped.replace(/'/g, "\\'") %>
    eval $'<%= cmdEscaped %>'
  <% }); %>
}
<% } %>

init_integrations() {
  # : to allow empty section
  :
  <% if (obj.integrationInitScripts.length > 0) { %>
    exec_cmd 'echo "Initializing CLI integrations"'
    <% _.each(obj.integrationInitScripts, function (integrationInitScript) { %>
    <%= integrationInitScript %>
    <% }); %>
  <% } %>
}

task() {
  ret=0
  is_success=false

  init_integrations
  trap before_exit EXIT
  [ "$ret" != 0 ] && return $ret;

  <% _.each(obj.script, function(cmd) { %>
  <% var cmdEscaped = cmd.replace(/\\/g, '\\\\')%>
  <% cmdEscaped = cmdEscaped.replace(/'/g, "\\'") %>
  <%
  // Do NOT remove the '$' below. It is necessary to ensure that our quoting
  // strategy works. See http://stackoverflow.com/a/16605140 for details
  %>
    exec_cmd $'<%= cmdEscaped %>'
    ret=$?
  <%
  // Reset the trap. Commands run inside the section may set traps of their own
  // and override what we need.
  %>
  trap before_exit EXIT
  [ "$ret" != 0 ] && return $ret;
  <% }); %>

  cleanup_integrations
  trap before_exit EXIT
  [ "$ret" != 0 ] && return $ret;

  ret=0
  is_success=true
  return $ret
}

cleanup_integrations() {
  # : to allow empty section
  :
  <% if (obj.integrationInitScripts.length > 0) { %>
    exec_cmd 'echo "Cleaning CLI integrations"'
    <% _.each(obj.integrationCleanupScripts, function (integrationCleanupScript) { %>
    <%= integrationCleanupScript %>
    <% }); %>
  <% } %>
}

<% if (obj.container) { %>
trap before_exit EXIT
exec_grp "symlink_build_dir" "Symlinking /build dir" "false"
<% } %>

trap before_exit EXIT
exec_grp "add_subscription_ssh_key" "Adding Subscription SSH Key" "false"

trap before_exit EXIT
exec_grp "task" "<%= obj.name %>"
