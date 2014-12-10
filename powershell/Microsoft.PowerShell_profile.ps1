$ODataBase = "C:\OData"
$ODataStartupCommandRelative = "_BuildCommon\Scripts\Startup.cmd"

Function StartupOData
{
    param(
        [Parameter(Mandatory = $true)]
        [int]$enlistment_id
    )
    
    $ODataStartupPath = "${ODataBase}\Main${enlistment_id}"
    $ODataStartupCommand = "${ODataStartupPath}\${ODataStartupCommandRelative}"
	$env:CBT_SHELL = "PowerShell"

    Invoke-Expression $ODataStartupCommand
}

Set-Alias od StartupOData

if (-not "$PWD".StartsWith($ODataBase))
{
    Set-Location $HOME
}