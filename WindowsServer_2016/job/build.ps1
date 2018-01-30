Function main([string] $scriptPath, [string] $envsPath) {
  <%= obj.reqExecCommand %> "$scriptPath" "$envsPath"
}

main @args
