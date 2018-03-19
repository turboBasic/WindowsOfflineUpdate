$projectRoot = Resolve-Path $PSScriptRoot\..
$moduleRoot = Split-Path (Resolve-Path $projectRoot\*\*.psm1)
$moduleName = Split-Path $moduleRoot -Leaf
$projectRoot, $moduleRoot, $moduleName | Write-Host

Describe "General project validation: $moduleName" {

    $scripts = Get-ChildItem $projectRoot -Include *.ps1,*.psm1,*.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object { @{ file = $_}  }

    It "Script <file> should be valid powershell" -TestCases $testCase {
        Param( $file )

        $file.FullName | Should -Exist

        $contents = Get-Content -Path $file.FullName -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize( $contents, [ref] $errors )
        $errors.Count | Should -Be 0
    }

    It "Module '$moduleName' can import cleanly" {
        {Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force } | Should -Not -Throw
    }
}

Describe "Validate update metadata" {
    InModuleScope $moduleName {
        It "Metadata not empty" {
            (Find-UpdateMetadata).articleId | Should -Not -BeNullOrEmpty
        }

        It "Finds update articles for all builds" {
            10240, 10586, 14393, 15063, 16299 |
                ForEach-Object {
                    $currentVersion = $_
                    Find-UpdateMetadata |
                        Where-Object { $_.Version.Major -eq $currentVersion } |
                        Should -Not -BeNullOrEmpty
                }
        }
    }
}


Describe "Validate article IDs" {
    InModuleScope $moduleName {
        Mock Find-AssetGuid {}

        10240, 10586, 14393, 15063, 16299 |
            ForEach-Object {
                $currentVersion = $_
                Find-UpdateMetadata |
                    Where-Object { $_.Version.Major -eq $currentVersion } |
                    Select-Object -First 1 -ExpandProperty articleId |
                    Find-AssetGuid
            }

        It "Finds asset GUIDs for all builds" {
            Assert-MockCalled Find-AssetGuid -times 5
        }
    }
}

