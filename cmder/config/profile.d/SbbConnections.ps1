function global:Stop-EthernetAdapters() {
    Write-Host "Disabling Ethernet adapters"
    get-netadapter "*Ethernet*" | disable-netadapter -confirm:$false
}

function global:Start-EthernetAdapters() {
    Write-Host "Enabling Ethernet adapters"
    get-netadapter "*Ethernet*" | enable-netadapter -confirm:$false
}

function global:Stop-SbbProxy() {
    Enable-SbbProxy $false
}

function global:Start-SbbProxy() {
    Enable-SbbProxy $true
}

function global:Stop-SbbProxy() {
    Enable-SbbProxy $false
}
function global:Enable-SbbProxy($enable) {
    if ($enable) {
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name ProxyEnable 1
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name AutoConfigURL "http://pac.zscloud.net/sbb.ch/proxy.pac"

        # set http proxy. this does not create duplicate values
        # even if the key already exists
        git config --system --replace-all http.proxy "http://zscaler.sbb.ch:9400"
    } else {
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name ProxyEnable 0
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -name AutoConfigURL ""

        # ensure we don't have the error 'duplicate values'
        git config --system --replace-all http.proxy "-"
        git config --system --unset http.proxy
   }
}

function global:Enable-Wifi($name) {
    Disable-Wifi
    Write-Host "Connecting to WLAN $name"
    netsh wlan connect $name
}

function global:Disable-Wifi() {
    Write-Host "Disconnecting all WLAN"
    netsh wlan disconnect
}

function global:Start-FlushDns {
    Write-Host "Flushing DNS"
    ipconfig /flushdns
    Start-Sleep 5
    ipconfig /flushdns
}

function global:Connect-SbbWifiCorporateSec {
    Stop-EthernetAdapters
    Start-SbbProxy
    Enable-Wifi "CorporateSec"
    Start-FlushDns
}
function global:Connect-SbbWifiFree {
    Stop-EthernetAdapters
    Stop-SbbProxy
    Enable-Wifi "SBB-FREE"
    Start-FlushDns
    Write-Host "You might have to accept usage terms, starting browser..."
    . "C:\Program Files\internet explorer\iexplore.exe" "http://freewlan.sbb.ch/"
}
function global:Connect-SbbEthernet {
    Disable-Wifi
    Start-EthernetAdapters
    Start-SbbProxy
    Start-FlushDns
}
