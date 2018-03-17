$projectRoot = Resolve-Path $PSScriptRoot\..
$moduleRoot = Split-Path (Resolve-Path $projectRoot\*\*.psm1)
$moduleName = Split-Path $moduleRoot -Leaf


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


Describe "Validation of update metadata" {

    InModuleScope $moduleName {
        $updates = Get-UpdateJson $startKB

        It "Update links should be available" {
            $updates | ConvertFrom-Json | Should -Not -BeNullOrEmpty
        }

        $articles = Find-KBArticleWithUpdate -source $updates -build '16299'
        $kbId = Find-ArticleUri -article $articles |
            Sort-Object -Property Version -Descending |
            Select-Object -First 1

        $kbContent = Invoke-WebRequest -Uri $kbId.Uri
        Write-Host $kbId.Uri

        $elementIDs = $kbContent.InputFields |
        Where-Object { $_.Type -eq 'Button' -and $_.Value -eq 'Download' } |
        Select-Object -ExpandProperty ID

        It "Article should contain Download buttons" {
            $kbContent.InputFields |
            Where-Object { $_.Type -eq 'Button' -and $_.Value -eq 'Download' } |
            Measure-Object |
            Select-Object -ExpandProperty Count | Should -BeGreaterThan 1
        }
    }

}
