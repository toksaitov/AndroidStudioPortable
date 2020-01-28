#Requires -Version 2.0

<#
    .SYNOPSIS
        Sets environment variables to local directories and starts
        the Android Studio.
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
# Set environment variables.
#

$env:HOMEPATH =
    Expand-Path -Path $PortableHomeDirectory
$env:USERPROFILE =
    Expand-Path -Path $PortableHomeDirectory
$env:ANDROID_HOME =
    Expand-Path -Path $AndroidSDKDirectory
$env:ANDROID_SDK_HOME =
    Expand-Path -Path $PortableHomeDirectory
$env:GRADLE_USER_HOME =
    Expand-Path -Path $GradleUserHomeDirectory

$env:PATH =
    "$(Expand-Path -Path $AndroidStudioBinariesDirectory);$env:PATH"

foreach ($Directory in $AndroidSDKBinariesDirectories)
{
    $env:PATH =
        "$(Expand-Path -Path $Directory);$env:PATH"
}

#
# Start the Android Studio.
#

Set-Location -Path $AndroidStudioBinariesDirectory

& $AndroidStudioExecutable
