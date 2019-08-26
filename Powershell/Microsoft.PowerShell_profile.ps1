$total = [System.Diagnostics.StopWatch]::StartNew()

Write-Host "Loading powershell profile ..."
$scriptsDir = "C:\tools\cmder\config\profile.d"

function ImportModule($name) {
    $sw = [System.Diagnostics.StopWatch]::StartNew()
    Write-Host "* Loading module '" -f Gray -NoNewline
    Write-Host $name -f Cyan -NoNewline
    Write-Host "' " -f Gray -NoNewline
    Import-Module $name
    Write-Host "OK" -f Green -NoNewline
    Write-Host ", took $($sw.ElapsedMilliseconds)ms" -f Gray
}

function ImportDotSourced($name) {
    $sw = [System.Diagnostics.StopWatch]::StartNew()
    Write-Host "* Loading script '" -f Gray -NoNewline
    Write-Host $name -f Cyan -NoNewline
    Write-Host "' " -f Gray -NoNewline
    . "$scriptsDir\$name.ps1"
    Write-Host "OK" -f Green -NoNewline
    Write-Host ", took $($sw.ElapsedMilliseconds)ms" -f Gray
}

ImportDotSourced 'SbbConnections'
ImportDotSourced 'SbbCitrix'
ImportDotSourced 'SbbDevEnv'
ImportDotSourced 'SbbGit'
ImportDotSourced 'SbbConnections'
ImportModule 'posh-git'

Write-Host "`nLoaded powershell profile, took $($total.ElapsedMilliseconds)ms"