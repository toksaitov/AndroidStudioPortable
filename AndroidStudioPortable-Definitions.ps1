#Requires -Version 2.0

<#
    .SYNOPSIS
        Definitions for a portable Android development environment

    .NOTES
        To update a package, update its name and its URL, then execute

            Remove-AndroidStudioPortable.ps1
            Setup-AndroidStudioPortable.ps1

        The configuration directory specified in `$PortableHomeDirectory`
        will be untouched.
 #>

$PortabelHomeDirectoryName =
    'portable-home'
$PortableHomeDirectory =
    ".\$PortabelHomeDirectoryName"

$AndroidSDK =
    'android-sdk_r24.4.1-windows'
$AndroidSDKArchive =
    "$AndroidSDK.zip"
$AndroidSDKURL =
    "https://dl.google.com/android/$AndroidSDKArchive"
$AndroidSDKDirectory =
    ".\$AndroidSDK\android-sdk-windows"
$AndroidSDKBinariesDirectories = @(
    "$AndroidSDKDirectory\tools",
    "$AndroidSDKDirectory\platform-tools"
)

$AndroidStudio =
    'android-studio-ide-143.3101438-windows'
$AndroidStudioArchive =
    "$AndroidStudio.zip"
$AndroidStudioURL =
    'https://dl.google.com/dl/android/studio/ide-zips/2.1.3.0/' +
        $AndroidStudioArchive
$AndroidStudioDirectory =
    ".\$AndroidStudio\android-studio"
$AndroidStudioBinariesDirectory =
    "$AndroidStudioDirectory\bin"
$AndroidStudioUserHomeDirectory =
    "`${idea.home}/../../$PortabelHomeDirectoryName"
$AndroidStudioHomeDirectory =
    "$AndroidStudioUserHomeDirectory/.AndroidStudio2.1"
$AndroidStudioExecutable =
    'studio64.exe'
$AndroidStudioConfigurationFile =
    "$AndroidStudioDirectory\bin\idea.properties"
$AndroidStudioAdditionalParameters = @(
    "idea.config.path=$AndroidStudioHomeDirectory/config",
    "idea.system.path=$AndroidStudioHomeDirectory/system",
    "idea.plugins.path=$AndroidStudioHomeDirectory/config/plugins"
)
$AndroidStudioVMConfigurationFiles = @(
    "$AndroidStudioDirectory\bin\studio.exe.vmoptions",
    "$AndroidStudioDirectory\bin\studio64.exe.vmoptions"
)
$AndroidStudioAdditionalVMParameters = @(
    "-Duser.home=$AndroidStudioUserHomeDirectory/"
)
$AndroidStudioBatchFile =
    '.\Start-AndroidStudioPortable.bat'

$GradleUserHomeDirectory =
    "$PortableHomeDirectory\.gradle"

$OracleJDK =
    'jdk-8u101-windows-x64'
$OracleJDKInstaller =
    "$OracleJDK.exe"
$OracleJDKURL =
    "http://download.oracle.com/otn-pub/java/jdk/8u101-b13/$OracleJDKInstaller"
$OracleJDKInternalArchive =
    'tools.zip'
$OracleJDKDirectory =
    ".\$OracleJDK"
$OracleJDKBinariesDirectory =
    "$OracleJDKDirectory\bin"

$LessMSI =
    'lessmsi-v1.4'
$LessMSIArchive =
    "$LessMSI.zip"
$LessMSIURL =
    'https://github.com/activescott/lessmsi/releases/download/v1.4/' +
        $LessMSIArchive
$LessMSIDirectory =
    ".\$LessMSI"
$LessMSIExecutable =
    'lessmsi.exe'

$7z =
    '7z1602-x64'
$7zInstaller =
    "$7z.msi"
$7zURL =
    "http://d.7-zip.org/a/$7zInstaller"
$7zDirectory =
    ".\$7z\SourceDir\Files\7-Zip"
$7zExecutable =
    '7z.exe'
