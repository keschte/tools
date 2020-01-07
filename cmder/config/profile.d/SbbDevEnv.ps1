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

function global:Set-VisualStudioDefenderExclusions() {
    Write-Host "This script will create Windows Defender exclusions for common Visual Studio folders and processes."
    Write-Host ""

    $pathExclusions = New-Object System.Collections.ArrayList
    $pathExclusions.Add('C:\Windows\Microsoft.NET') | Out-Null
    $pathExclusions.Add('C:\Windows\assembly') | Out-Null
    $pathExclusions.Add('C:\ProgramData\Microsoft\VisualStudio\Packages') | Out-Null
    $pathExclusions.Add('C:\Program Files (x86)\MSBuild') | Out-Null
    $pathExclusions.Add('C:\Program Files (x86)\Microsoft Visual Studio') | Out-Null
    $pathExclusions.Add('C:\Program Files (x86)\Microsoft SDKs\NuGetPackages') | Out-Null
    $pathExclusions.Add('C:\Program Files (x86)\Microsoft SDKs') | Out-Null
    $pathExclusions.Add('C:\devsbb') | Out-Null
    $pathExclusions.Add('C:\projects') | Out-Null

    $userPath = $env:USERPROFILE
    $pathExclusions.Add($userPath + '\AppData\Local\Microsoft\VisualStudio') | Out-Null

    $processExclusions = New-Object System.Collections.ArrayList
    $processExclusions.Add('devenv.exe') | Out-Null
    $processExclusions.Add('dotnet.exe') | Out-Null
    $processExclusions.Add('msbuild.exe') | Out-Null
    $processExclusions.Add('node.exe') | Out-Null
    $processExclusions.Add('node.js') | Out-Null
    $processExclusions.Add('perfwatson2.exe') | Out-Null
    $processExclusions.Add('ServiceHub.Host.Node.x86.exe') | Out-Null
    $processExclusions.Add('vbcscompiler.exe') | Out-Null
    $processExclusions.Add('testhost.exe') | Out-Null
    $processExclusions.Add('datacollector.exe') | Out-Null
    $processExclusions.Add('IntelliTrace.exe') | Out-Null
    $processExclusions.Add('CodeCoverage.exe') | Out-Null
    $processExclusions.Add('code.exe') | Out-Null

    foreach ($exclusion in $pathExclusions) {
        Write-Host "Adding path exclusion: $exclusion"
        Add-MpPreference -ExclusionPath $exclusion
    }

    foreach ($exclusion in $processExclusions) {
        Write-Host "Adding process exclusion: $exclusion"
        Add-MpPreference -ExclusionProcess $exclusion
    }

    $prefs = Get-MpPreference

    Write-Host ""
    Write-Host "Your path exclusions:"
    $prefs.ExclusionPath

    Write-Host ""
    Write-Host "Your process exclusions:"
    $prefs.ExclusionProcess
}


# print current variables...
# [System.Environment]::GetEnvironmentVariables()