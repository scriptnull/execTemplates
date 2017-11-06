<% _.each(obj.envs, function (env) { %>
{
  export <%= env %>;
} || {
  exec_cmd "echo 'An error occurred while trying to export an environment variable: <%= env.split('=')[0] %> '"
  return 1
}
<% }); %>
