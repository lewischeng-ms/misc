# Modify the following variables as appropriate.
$NugetPackageDir = "C:\NuGetPackages"
$FxCopVersion = "6.1"
$CustomRulesVersion = "6.1.0.61781"
$ODataDir = "C:\OData\Main5"
$OutputDir = "C:\FxCopOut"

# Auto-computed variables.
$FxCopToolsDir = "$NugetPackageDir\Microsoft.FxCop.SDL.SQLIS.$FxCopVersion\Tools"
$FxCopCmd = "$FxCopToolsDir\FxCopCmd.exe"
$SecurityRulesFile = "$FxCopToolsDir\Rules\SecurityRules.dll"
$DataWebRulesFile = "$NugetPackageDir\Microsoft.OData.CustomFxCopRules.$CustomRulesVersion\Rules\DataWebRules.dll"
$ProductRelativeDir = "bin\AnyCPU\Release\Product"
$NETPortableDir = "$ProductRelativeDir\.NETPortable\v4.0"
$DesktopDir = "$ProductRelativeDir\Desktop"
$ClientPortableDll = "Microsoft.OData.Client.Portable.dll"
$ClientDll = "Microsoft.OData.Client.dll"
$CoreDll = "\Microsoft.OData.Core.dll"
$EdmDll = "Microsoft.OData.Edm.dll"
$SpatialDll = "Microsoft.Spatial.dll"

# Create $OutputDir if not exist.
if(![System.IO.Directory]::Exists($OutputDir))
{
    New-Item -path $OutputDir -type directory -Force
}

# Spatial
Invoke-Expression "$FxCopCmd /out:$OutputDir\$SpatialDll.CodeAnalysisLog.xml /file:$DesktopDir\$SpatialDll /s /rule:$DataWebRulesFile /rule:$SecurityRulesFile"

# Edm
Invoke-Expression "$FxCopCmd /out:$OutputDir\$EdmDll.CodeAnalysisLog.xml /file:$DesktopDir\$EdmDll /s /rule:$SecurityRulesFile"

# Core
Invoke-Expression "$FxCopCmd /out:$OutputDir\$CoreDll.CodeAnalysisLog.xml /file:$DesktopDir\$CoreDll /s /rule:$SecurityRulesFile"

# Client
Invoke-Expression "$FxCopCmd /out:$OutputDir\$ClientDll.CodeAnalysisLog.xml /file:$DesktopDir\$ClientDll /s /rule:$SecurityRulesFile"

# Client Portable
Invoke-Expression "$FxCopCmd /out:$OutputDir\$ClientPortableDll.CodeAnalysisLog.xml /file:$NETPortableDir\$ClientPortableDll /s /rule:$SecurityRulesFile"