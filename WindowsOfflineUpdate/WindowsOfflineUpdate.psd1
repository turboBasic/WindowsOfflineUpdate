@{
    # If authoring a script module, the RootModule is the name of your .psm1 file
    RootModule = 'WindowsOfflineUpdate.psm1'

    Author = 'Andriy Melnyk <mao@bebee.xyz>'

    CompanyName = 'Cargonautica'

    ModuleVersion = '0.1'

    # Use the New-Guid command to generate a GUID, and copy/paste into the next line
    GUID = 'fe7cc4f9-df82-40d9-a381-417d5d01e5c5'

    Copyright = '2018 Andriy Melnyk'

    Description = 'Powershell module for injecting updates into Windows and Windows Server offline installation images'

    # Minimum PowerShell version supported by this module (optional, recommended)
    PowerShellVersion = '5.0'

    # Which PowerShell Editions does this module work with? (Core, Desktop)
    CompatiblePSEditions = @('Desktop', 'Core')

    # Which PowerShell functions are exported from your module? (eg. Get-CoolObject)
    FunctionsToExport = @('Find-LatestUpdate')

    # Which PowerShell aliases are exported from your module? (eg. gco)
    AliasesToExport = @('')

    # Which PowerShell variables are exported from your module? (eg. Fruits, Vegetables)
    VariablesToExport = @('')

    # PowerShell Gallery: Define your module's metadata
    PrivateData = @{
        PSData = @{
            # What keywords represent your PowerShell module? (eg. cloud, tools, framework, vendor)
            Tags = @('tools', 'update', 'deployment')

            # What software license is your code being released under? (see https://opensource.org/licenses)
            LicenseUri = ''

            # What is the URL to your project's website?
            ProjectUri = 'https://github.com/turboBasic/WindowsOfflineUpdate'

            # What is the URI to a custom icon file for your project? (optional)
            IconUri = ''

            # What new features, bug fixes, or deprecated features, are part of this release?
            ReleaseNotes = @'
'@
        }
    }

    # If your module supports updateable help, what is the URI to the help archive? (optional)
    # HelpInfoURI = ''
}
