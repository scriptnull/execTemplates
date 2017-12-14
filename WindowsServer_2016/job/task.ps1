Function task() {
  <% _.each(obj.script, function(cmd) { %>
    exec_cmd '<%= cmd %>'
  <% }) %>
}

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
