function global:Stop-SbbCitrix {
    Get-Process | Select-Object Id,Path | Where-Object { "$_.Path".ToLower().Contains("citrix") } | Stop-Process -Force
}

function global:Start-SbbCitrix {
    & "C:\Program Files (x86)\Citrix\ICA Client\concentr.exe" /startup
    & "C:\Program Files (x86)\Citrix\ICA Client\redirector.exe" /startup
    & "C:\Program Files (x86)\Citrix\ICA Client\SelfServicePlugin\SelfService.exe" -poll
    & "C:\Program Files\Citrix\Secure Access Client\nsload.exe"
}