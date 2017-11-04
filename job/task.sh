#
# generating exec_cmd for each script in task section
#
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

exec_grp "task" "<%= obj.name %>"
