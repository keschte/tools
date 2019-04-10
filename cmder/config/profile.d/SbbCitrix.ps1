function Stop-SbbCitrix {
    Get-Process | Select-Object Id,Path | Where-Object { "$_.Path".ToLower().Contains("citrix") } | Stop-Process -Force
}