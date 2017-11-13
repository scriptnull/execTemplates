#
# The script to run the user provided commands is generated here
#

# Adding this to support build directory expected with genExec
symlink_build_dir() {
  ln -s $BUILD_DIR /build
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

task() {
  ret=0
  is_success=false
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
  ret=0
  is_success=true
  return $ret
}

<% if (obj.container) { %>
trap before_exit EXIT
exec_grp "symlink_build_dir" "Symlinking /build dir" "false"
<% } %>

trap before_exit EXIT
exec_grp "task" "<%= obj.name %>"
