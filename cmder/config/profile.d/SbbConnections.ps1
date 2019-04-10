function Enable-SbbProxy($enable) {
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

function Enable-Wifi($name) {
    Disable-Wifi
    netsh wlan connect $name
}

function Disable-Wifi() {
    netsh wlan disconnect
}

function Start-FlushDns {
  ipconfig /flushdns
}

function Connect-SbbWifiCorporateSec {
    get-netadapter "*Ethernet*" | disable-netadapter -confirm:$false
    Enable-SbbProxy $true
    Enable-Wifi "CorporateSec"
    Start-FlushDns
}
function Connect-SbbWifiFree {
    get-netadapter "*Ethernet*" | disable-netadapter -confirm:$false
    Enable-SbbProxy $false
    Enable-Wifi "SBB-FREE"
    Start-FlushDns
    Sleep 5
    . "C:\Program Files\internet explorer\iexplore.exe" "http://freewlan.sbb.ch/"
}
function Connect-SbbEthernet {
    get-netadapter "*Ethernet*" | enable-netadapter -confirm:$false
    Enable-SbbProxy $true
    Disable-Wifi
    Start-FlushDns
}
