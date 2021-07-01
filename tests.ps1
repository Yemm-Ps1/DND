Set-Location "C:\Users\Danny\Workspace\PowershellProjects\DND"
Clear-Host
Write-Host "RUNNING"
Invoke-Pester -Path .\src\RollUtil.Tests.ps1
