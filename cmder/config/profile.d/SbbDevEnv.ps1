function SetEnvironmentVariable($key, $value, $scope = "User") {
    if ($key -eq "NUGET_PACKAGES") {
        if ($null -eq (Get-Item $value -ea SilentlyContinue)) {
            New-Item -ItemType directory -Path $path
        }
    }

    $currentValue = [Environment]::GetEnvironmentVariable($key)
    if ($currentValue -ne $value) {
        [Environment]::SetEnvironmentVariable($key, $path, $scope)
    }
}

SetEnvironmentVariable "DEV_HOME" "C:\devsbb" "Process"
SetEnvironmentVariable "NUGET_PACKAGES" "c:\devsbb\_nuget" "Process"
SetEnvironmentVariable "HOMESHARE" "c:\users\$($env:UserName)" "Process"

# clear the process PSModulePath variable. This effectively removes
# the timeouts when trying to access the filer path (\\filer17\users175\{user}\PowerShell\Modules)
$psModulePath = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
[System.Environment]::SetEnvironmentVariable("PSModulePath", $psModulePath, "Process")

# print current variables...
# [System.Environment]::GetEnvironmentVariables()