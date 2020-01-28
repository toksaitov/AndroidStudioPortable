#Requires -Version 2.0

<#
    .SYNOPSIS
        Removes all installed packages but leaves the configuration
        directory specified in `$PortableHomeDirectory`.
 #>

#
# Definitions
#

. '.\AndroidStudioPortable-Definitions.ps1'

#
# Helpers
#

. '.\AndroidStudioPortable-Helpers.ps1'

#
# Cleanup Tools
#
. '.\Remove-SetupTemporaryFiles.ps1'


#
# Remove installed packages.
#

$AndroidSDKRootDirectory =
    Get-RelativeRootDirectory -RelativePath $AndroidSDKDirectory
$AndroidStudioRootDirectory =
    Get-RelativeRootDirectory -RelativePath $AndroidStudioDirectory

#
# 260 characters workaround
#

& 'CMD' '/C' 'RMDIR' '/S' '/Q' $AndroidSDKRootDirectory 2>&1 |
    Out-Null
& 'CMD' '/C' 'RMDIR' '/S' '/Q' $AndroidStudioRootDirectory 2>&1 |
    Out-Null

$InstalledPackages = @(
    $AndroidSDKRootDirectory,
    $AndroidStudioRootDirectory
)

$RemoveItemParameters = @{
    Path = $InstalledPackages;
    ErrorAction = 'SilentlyContinue';
}
Remove-Item @RemoveItemParameters -Recurse -Force
