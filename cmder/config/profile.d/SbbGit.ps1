function Update-SbbGitRepositories {
    Get-ChildItem "c:\devsbb" | ForEach-Object {
        $path = $_.FullName
        Write-Host "Updating $path ..."
        Push-Location $path
        git pull --ff-only
        Pop-Location
    }
}