Function task() {
  <% _.each(obj.script, function(cmd) { %>
    exec_cmd '<%= cmd %>'
  <% }) %>
}
<% if (obj.onSuccess) { %>
Function on_success() {
  <% _.each(obj.onSuccess.script, function(cmd) { %>
    Invoke-Expression $'<%= cmd %>'
  <% }); %>
}
<% } %>

Function main() {
  $global:is_success = $TRUE
  Try
  {
    exec_grp "task" "Executing Task $TASK_NAME"
  }
  Catch
  {
    $global:is_success = $FALSE
  }
  Finally
  {
    before_exit
  }
}

main
