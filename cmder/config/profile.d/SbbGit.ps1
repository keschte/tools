function global:Update-SbbGitRepositories {
    $rootPath = Get-SbbDevPath
    Get-ChildItem $rootPath | ForEach-Object {
        try {
            $path = $_.FullName
            Write-Host "Updating $path ..."
            Push-Location $path
            git pull --ff-only
            Pop-Location
        } catch {
            Write-Error "Failed to update: $_"
        } finally {
            Pop-Location
        }
    }
}