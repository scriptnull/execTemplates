Function task() {
  <% _.each(obj.script, function(cmd) { %>
    exec_cmd '<%= cmd %>'
  <% }) %>
}
<% if (obj.onSuccess) { %>
Function on_success() {
  <% _.each(obj.onSuccess.script, function(cmd) { %>
    Invoke-Expression '<%= cmd %>'
  <% }); %>
}
<% } %>

<% if (obj.onFailure) { %>
Function on_failure() {
  <% _.each(obj.onFailure.script, function(cmd) { %>
    Invoke-Expression '<%= cmd %>'
  <% }); %>
}
<% } %>

Function before_exit() {
  if ($global:is_success) {
    if (Get-Command "on_success" -errorAction SilentlyContinue)
    {
      exec_cmd "on_success"
    }

    Write-Output "__SH__SCRIPT_END_SUCCESS__";
  } else {
    if (Get-Command "on_failure" -errorAction SilentlyContinue)
    {
      exec_cmd "on_failure"
    }

    Write-Output "__SH__SCRIPT_END_FAILURE__";
  }
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
