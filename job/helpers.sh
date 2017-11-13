### HELPERS

# docker login command doesn't accept --email flag after docker 17.06

_is_docker_email_deprecated() {
  local docker_version=""
  local docker_major_version=""
  local email_deprecated_version=17

  docker_version="$( docker version --format \{\{.Server.Version\}\} )"
  docker_major_version=$(echo "$docker_version" | awk -F '.' '{print $1}')

  [[ "$docker_major_version" -ge "$email_deprecated_version" ]]
}
