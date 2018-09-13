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

$AndroidSDKDirectory =
    ".\android-sdk-windows"
$AndroidSDKBinariesDirectories = @(
    "$AndroidSDKDirectory\tools",
    "$AndroidSDKDirectory\platform-tools"
)

$AndroidStudio =
    'android-studio-ide-173.4907809-windows'
$AndroidStudioArchive =
    "$AndroidStudio.zip"
$AndroidStudioURL =
    "https://dl.google.com/dl/android/studio/ide-zips/3.1.4.0/$AndroidStudioArchive"
$AndroidStudioDirectory =
    ".\$AndroidStudio\android-studio"
$AndroidStudioBinariesDirectory =
    "$AndroidStudioDirectory\bin"
$AndroidStudioUserHomeDirectory =
    "`${idea.home}/../../$PortabelHomeDirectoryName"
$AndroidStudioHomeDirectory =
    "$AndroidStudioUserHomeDirectory/.AndroidStudio3.1"
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
    'jdk-8u181-windows-x64'
$OracleJDKInstaller =
    "$OracleJDK.exe"
$OracleJDKURL =
    "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/$OracleJDKInstaller"
$OracleJDKdlCookie =
    "Cookie: oraclelicense=accept-securebackup-cookie"
$OracleJDKInternalCABPath =
    '.rsrc\1033\JAVA_CAB10'
$OracleJDKInternalCAB =
    '111'
$OracleJDKInternalArchive =
    'tools.zip'
$OracleJDKDirectory =
    ".\$OracleJDK"
$OracleJDKBinariesDirectory =
    "$OracleJDKDirectory\bin"

$LessMSI =
    'lessmsi-v1.6.1'
$LessMSIArchive =
    "$LessMSI.zip"
$LessMSIURL =
    'https://github.com/activescott/lessmsi/releases/download/v1.6.1/' +
        $LessMSIArchive
$LessMSIDirectory =
    ".\$LessMSI"
$LessMSIExecutable =
    'lessmsi.exe'

$7z =
    '7z1805-x64'
$7zInstaller =
    "$7z.msi"
$7zURL =
    "http://d.7-zip.org/a/$7zInstaller"
$7zDirectory =
    ".\$7z\SourceDir\Files\7-Zip"
$7zExecutable =
    '7z.exe'

$aria2 =
    'aria2-1.34.0-win-64bit-build1'
$aria2Archive =
    "$aria2.zip"
$aria2URL =
    "https://github.com/aria2/aria2/releases/download/release-1.34.0/$aria2Archive"
$aria2Directory =
    ".\$aria2"
$aria2Executable =
    "$aria2\aria2c.exe"
	