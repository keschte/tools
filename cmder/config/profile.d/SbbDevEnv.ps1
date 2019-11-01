function SetEnvironmentVariable($key, $value, $scope = "User") {
    if ($key -eq "NUGET_PACKAGES") {
        if ($null -eq (Get-Item $value -ea SilentlyContinue)) {
            New-Item -ItemType directory -Path $value | Out-Null
        }
    }

    $currentValue = [Environment]::GetEnvironmentVariable($key, $scope)
    if ($currentValue -ne $value) {
        [Environment]::SetEnvironmentVariable($key, $value, $scope)
        # Write-Debug "Environment variable '$key' set to '$value'"
    } else {
        Write-Debug "Environment variable '$key' is already set"
    }
}

$devSbb = [Environment]::GetEnvironmentVariable("DEVSBB", "Machine")
if (-not $devSbb) {
    Write-Debug "Environment variable 'DEVSBB' is not set, assuming default"
    $devSbb = "c:\devsbb"
}

SetEnvironmentVariable "DEVSBB" "$devSbb" "User"
SetEnvironmentVariable "NUGET_PACKAGES" "$devSbb\_nuget" "User"
SetEnvironmentVariable "HOMESHARE" "c:\users\$($env:UserName)" "User"

# clear the process PSModulePath variable. This effectively removes
# the timeouts when trying to access the filer path (\\filer17\users175\{user}\PowerShell\Modules)
$psModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
[System.Environment]::SetEnvironmentVariable("PSModulePath", $psModulePath, "Process")

function global:Get-SbbDevPath() {
    $devSbb = [Environment]::GetEnvironmentVariable("DEVSBB", "Machine")
    if (-not $devSbb) {
        Write-Debug "Environment variable 'DEVSBB' is not set, assuming default"
        $devSbb = "c:\devsbb"
    }
    return $devSbb
}

# print current variables...
# [System.Environment]::GetEnvironmentVariables()