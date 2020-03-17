function global:Update-SbbGitRepositories {
    $rootPath = Get-SbbDevPath
    Get-ChildItem $rootPath | ForEach-Object {
        try {
            $path = $_.FullName
            Write-Host "------------------ $path -------------------"
            Push-Location $path

            git pull --ff-only --prune
            git gc --prune

            Pop-Location
        } catch {
            Write-Error "Failed to update: $_"
        } finally {
            Pop-Location
            Write-Host
            Write-Host
        }
    }
}