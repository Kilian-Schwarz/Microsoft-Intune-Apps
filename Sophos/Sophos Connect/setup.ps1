<#
.Synopsis
Created on:   31.03.2022
Created by:   Kilian Schwarz
Filename:     setup.ps1
Version:      1.16.20
Description: Sophos Connect Setup über Microsoft Intune Unternehmensportal App

Microsoft Intune Unternehmensportal App Config:
        Herausgeber: Sophos ltd und Kilian Schwarz
        Entwickler: intunewin setup.ps1 Script - Kilian Schwarz _ Sophos Connect - Sophos
        Installationsbefehl: powershell.exe -executionpolicy bypass -file setup.ps1 -gateway "userportalfirewall.domain.de" -port "443"
        Deinstallationsbefehl: powershell.exe -executionpolicy bypass -file uninstall.ps1
        Installationsverhalten: System
        Betriebssystemarchitektur: x86,x64
.Example
powershell.exe -executionpolicy bypass -file setup.ps1 -gateway "userportalfirewall.domain.de" -port "443"
#>
Param (
    [Parameter(Mandatory=$True)]
    [string]$gateway,
    [Parameter(Mandatory=$True)]
    [string]$port
)

$Date = Get-Date -Format "yyyy_MM_dd_HH_mm"
$LOG_P = "C:\MS-Intune_LOG"
$LOG_F = "C:\MS-Intune_LOG\Install-$Date-log_Sophos_Connect_Installation.log"
$LOG_TS = "C:\MS-Intune_LOG\Install-$Date-TS_Sophos_Connect_Installation.log"
$SSL = "C:\Program Files (x86)\Sophos\Sophos SSL VPN Client\Uninstall.exe"
$VPNE = "Sophos-Connect-Config-Example.pro"
$VPNC = "Sophos-Connect-Config.pro"

Try
{
    if (Test-Path $LOG_P) 
    {
        echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : $LOG_P exisitert bereits" >> $LOG_F
    }
    else
    {
        New-Item -Type Directory -Path $LOG_P >> $Null
        echo "$LOG_P wurde erstellt" >> $LOG_F
    }
    Start-Transcript -Path $LOG_TS  >> $Null
    if (Test-Path $SSL) 
    {
        Get-Process -Name '*vpn*' | Stop-Process -Force
        Start-Process -FilePath $SSL -ArgumentList "/S /qn" -Wait
        echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : Sophos SSL VPN Client wurde ermittelt, gestopt und Deinstalliert." >> $LOG_F
    }
    else
    {
        echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : Konnte kein Sophos SSL VPN Client ermitteln." >> $LOG_F
    }
    $pro = Get-Content $VPNE
    $pro = $pro.Replace('%gateway%',$gateway).Replace('%port%',$port).Replace('%auto_connect_host%',$gateway)
    $pro | Add-Content -Path $VPNC
    echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : Sophos Provisioning File wurde durch Vorlage und Parameter fuer $gateway erstellt." >> $LOG_F
    ls >> $LOG_F
    try
    {
        Start-Process SophosConnect.msi -ArgumentList "/quiet" -Wait
    }
    Catch
    {

    }
    echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : SophosConnect wurde installiert" >> $LOG_F
    start "C:\Program Files (x86)\Sophos\Connect\GUI\scgui.exe"
    echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : SophosConnect wird gestartet" >> $LOG_F
    sleep 3
    start $VPNC
    echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : Sophos Provisioning File wird ausgefuehrt" >> $LOG_F
    sleep 3
    echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : tmp Ordner wurde geloescht" >> $LOG_F
    echo "$(Get-Date -UFormat "%Y_%m_%d %R %Z") : Installation beendet" >> $LOG_F
    Stop-Transcript  >> $Null
    return $true
}
Catch 
{
    Return $false
}
[Environment]::Exit(-1)