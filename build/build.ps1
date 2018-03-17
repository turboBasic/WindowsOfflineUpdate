Param ($Task = 'Default')


# Ensure PSDepend is available
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
if(-not (Get-Module -ListAvailable PSDepend))
{
    & (Resolve-Path $PSScriptRoot\helpers\Install-PSDepend.ps1)
}
Import-Module PSDepend


# Ensure dependencies are present
$null = Invoke-PSDepend -Path $PSScriptRoot\build.depend.psd1 -Install -Import -Force


# Set normalized build environment
Set-BuildEnvironment -force


# Build project
Invoke-Psake -buildFile $PSScriptRoot\psake.ps1 -taskList $Task -nologo


#
exit ( [int]( -not $psake.build_success ) )
