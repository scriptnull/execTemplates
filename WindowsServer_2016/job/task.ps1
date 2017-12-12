Function task() {
  exec_cmd dir
}

Function main() {
  Try
  {
    exec_grp "task" "Executing Task"
  }
  Finally
  {
    before_exit
  }
}

main
