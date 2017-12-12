Function task() {
  dir
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
