<#
.Synopsis
Created on:   14.04.2022
Created by:   Kilian Schwarz
Filename:     setup.ps1
Version:      1.1.1
Description:  Adobe Acrobat Reader Setup über Microsoft Intune Unternehmensportal App
GitHub:       https://github.com/Kilian-Schwarz/Microsoft-Intune-Apps

Microsoft Intune Unternehmensportal App Config:
        Herausgeber: Adobe und Kilian Schwarz
        Entwickler: intunewin setup.ps1 Script - Kilian Schwarz _ Adobe Acrobat Reader - Adobe
        Installationsbefehl: powershell.exe -executionpolicy bypass -file setup.ps1 
        Deinstallationsbefehl: powershell.exe -executionpolicy bypass -file uninstall.ps1
        Installationsverhalten: System
        Betriebssystemarchitektur: x86,x64
.Example
powershell.exe -executionpolicy bypass -file setup.ps1
#>


$Date = Get-Date -Format "yyyy_MM_dd_HH_mm"
$LOG_P = "$env:TEMP\MS-Intune_LOG\Adobe-Acrobat"
$LOG_F = "$LOG_P\Install-$Date-log_Adobe_Acrobat_Reader_Installation.log"
$LOG_TS = "$LOG_P\Install-$Date-TS_Adobe_Acrobat_Reader_Installation.log"

Try
{
    Start-Transcript -Path $LOG_TS  >> $Null

    Start-Process -wait setup.exe -ArgumentList "/sAll /msi /L*v $LOG_F"

    Stop-Transcript  >> $Null
    return $true
}
Catch 
{
    Return $false
}
[Environment]::Exit(-1)