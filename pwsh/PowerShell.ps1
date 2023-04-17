# Modules and Options
Import-Module -Name Terminal-Icons
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Aliases
# Set-Alias cl clear # Disable för att CTRL+L inte rensar historiken
Set-Alias g git

# Functions
function title($text) {
    if(!$text.Length -gt 0) {
        $gitloc = Get-GitLocation
        $Host.UI.RawUI.WindowTitle = $gitloc
    }
    else {
        $Host.UI.RawUI.WindowTitle = $text
    }
    return
}

function Get-GitLocation() {
    $ret = ""
    git branch 2>&1 `
    | Where-Object { $_ | Select-String "^\*" ` } `
    | ForEach-Object {
      if ($_ -match "\(HEAD detached at [0-9a-f]+\)") {
        $fst = $_.Substring(20)
        $ret = $fst.Substring(0, $fst.IndexOf(")"))
      } else {
        $ret = $_.Substring(2)
      }
    }
    return $ret
}
  
function prompt() {
    $prefix   = ""
    $branch   = Get-GitLocation
    $location = (Get-Location).Path
    $suffix = [Environment]::NewLine + $ENV:USERNAME + "$ "
    
    if ($branch.Length -gt 0) {
      $prefix = $branch + " | "
      $Host.UI.RawUI.WindowTitle = $branch
    } else {
        $Host.UI.RawUI.WindowTitle = "PowerShell"
    }
    return $prefix + $location + $suffix
}
