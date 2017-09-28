#!/bin/bash -e

is_empty() {
  [[ -z "$1" ]] || [[ "$1" == "null" ]]
}

csv_has_value() {
  local csv=$1
  local value=$2
  [[ $csv =~ (^|,)$value(,|$) ]]
}

is_docker_email_deprecated() {
  local docker_version=""
  local docker_major_version=""
  local email_deprecated_version=17

  docker_version="$( docker version --format \{\{.Server.Version\}\} )"
  docker_major_version=$(echo "$docker_version" | awk -F '.' '{print $1}')

  [[ "$docker_major_version" -ge "$email_deprecated_version" ]]
}
