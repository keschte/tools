New-Item -ItemType directory -Path "C:\devsbb\_nuget" -ea SilentlyContinue
[Environment]::SetEnvironmentVariable("NUGET_PACKAGES", "C:\devsbb\_nuget", "User")