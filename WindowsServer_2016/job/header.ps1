Function exec_cmd([string]$cmd) {
  $cmd_uuid = [guid]::NewGuid().Guid
  $cmd_start_timestamp = Get-Date -format "%s"
  Write-Output "__SH__CMD__START__|{`"type`":`"cmd`",`"sequenceNumber`":`"$cmd_start_timestamp`",`"id`":`"$cmd_uuid`"}|$cmd"

  $cmd_status = 0
  $ErrorActionPreference = "Stop"

  Try
  {
    $global:LASTEXITCODE = 0;
    Invoke-Expression $cmd
    $ret = $LASTEXITCODE
    if ($ret -ne 0) {
      $cmd_status = $ret
      Throw
    }
  }
  Catch
  {
    $cmd_status = 1
    Write-Output $_
    Throw
  }
  Finally
  {
    $cmd_end_timestamp = Get-Date -format "%s"
    Write-Output ""
    Write-Output "__SH__CMD__END__|{`"type`":`"cmd`",`"sequenceNumber`":`"$cmd_end_timestamp`",`"id`":`"$cmd_uuid`",`"exitcode`":`"$cmd_status`"}|$cmd"
  }
}

Function exec_grp([string]$group_name, [string]$group_message,[Bool]$is_shown = $TRUE) {
  if (-not ($group_message)) {
    group_message=$group_name
  }

  $group_uuid = [guid]::NewGuid().Guid
  # TODO: migrate to unix time if this does not work
  $group_start_timestamp = Get-Date -format "%s"
  Write-Output ""
  Write-Output "__SH__GROUP__START__|{`"type`":`"grp`",`"sequenceNumber`":`"$group_start_timestamp`",`"id`":`"$group_uuid`",`"is_shown`":`"$is_shown`"}|$group_message"

  $group_status = 0

  Try
  {
    Invoke-Expression $group_name
  }
  Catch
  {
    $group_status = 1
    Throw
  }
  Finally
  {
    # TODO: migrate to unix time if this does not work
    $group_end_timestamp = Get-Date -format "%s"
    Write-Output "__SH__GROUP__END__|{`"type`":`"grp`",`"sequenceNumber`":`"$group_end_timestamp`",`"id`":`"$group_uuid`",`"is_shown`":`"$is_shown`",`"exitcode`":`"$group_status`"}|$group_message"
  }
}
