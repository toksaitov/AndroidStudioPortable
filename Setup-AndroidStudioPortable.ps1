#Requires -Version 2.0

<#
    .SYNOPSIS
        Downloads, unpacks, and prepares a portable
        Android development environment.
 #>
 
# 
# First boost SSL to TLS1.2 
#

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

#
# Definitions
#

. '.\AndroidStudioPortable-Definitions.ps1'

#
# Helpers
#

. '.\AndroidStudioPortable-Helpers.ps1'

#
# Steps
#

#
# Download and unpack lessmsi to be able to unpack
# a 7-Zip installer later.
#

$ToolsAreRequired =
    !(Test-Path -Path $AndroidSDKDirectory)    -Or
    !(Test-Path -Path $AndroidStudioDirectory) -Or
    !(Test-Path -Path $OracleJDKDirectory)

if ($ToolsAreRequired -And !(Test-Path -Path $aria2Directory))
{
    if (!(Test-Path -Path $aria2Archive))
    {
        Write-Output "Get Aria2 Downloader"
        Invoke-FileDownload -Uri $aria2URL -OutFile $aria2Archive
    }
    Write-Output "Expand Aria2"
    Expand-Archive -Path $aria2Archive
}
	
if ($ToolsAreRequired -And !(Test-Path -Path $LessMSIDirectory))
{
    if (!(Test-Path -Path $LessMSIArchive))
    {
        Write-Output "Get LessMSI"
        & ".\$aria2Directory\$aria2Executable" -o $LessMSIArchive $LessMSIURL
    }
    Write-Output "Expand LessMSI"
    Expand-Archive -Path $LessMSIArchive
}

#
# Download and unpack the 7-Zip installer.
#

if ($ToolsAreRequired -And !(Test-Path -Path $7zDirectory))
{
    if (!(Test-Path -Path $7zInstaller))
    {
        Write-Output "Get 7-Zip"
        & ".\$aria2Directory\$aria2Executable" -o $7zInstaller $7zURL
    }

    Write-Output "Use LessMSI to unpack 7zip"
    & ".\$LessMSIDirectory\$LessMSIExecutable" 'x' $7zInstaller
}

#
# Download and unpack an Android Studio archive.
#

if (!(Test-Path -Path $AndroidStudioDirectory))
{
    if (!(Test-Path -Path $AndroidStudioArchive))
    {
        Write-Output "Download Android Studio $AndroidStudio"
        & ".\$aria2Directory\$aria2Executable" -c -o $AndroidStudioArchive $AndroidStudioURL 
    }

    Write-Output "Unpacking Android Studio"
    & ".\$7zDirectory\$7zExecutable" 'x' $AndroidStudioArchive '-o*' '-y'
}

#
# Download and unpack an Oracle JDK installer without administrative rights.
#

if (!(Test-Path -Path $OracleJDKDirectory))
{
    if (!(Test-Path -Path $OracleJDKInternalArchive))
    {
        if (!(Test-Path -Path $OracleJDKInternalCAB))
        {
            if (!(Test-Path -Path $OracleJDKInstaller))
            {
                #
                # Download the Oracle JDK installer accepting the
                #
                #     `Oracle Binary Code License Agreement for Java SE`
                #

				& ".\$aria2Directory\$aria2Executable" --header=$($OracleJDKdlCookie) -c -o $OracleJDKInstaller $OracleJDKURL
                
            }

            #
            # Unpack the Oracle JDK installer with 7-Zip.
            #

            Write-Output "Unpack JDK installer"
            & ".\$7zDirectory\$7zExecutable"                      `
                'e' $OracleJDKInstaller                           `
                "$OracleJDKInternalCABPath\$OracleJDKInternalCAB" `
                '-y'
        }

        #
        # Unpack the Oracle JDK Tools CAB with 7-Zip.
        #

        Write-Output "Unpack JDK archive"
        & ".\$7zDirectory\$7zExecutable"     `
            'e' $OracleJDKInternalCAB        `
            "$OracleJDKInternalArchive" '-y'
    }

    Write-Output "Unpack JDK"
    & ".\$7zDirectory\$7zExecutable" 'x' $OracleJDKInternalArchive `
                                     "-o$OracleJDKDirectory" '-y'
}

#
# Unpack Oracle JDK `.pack` files with the unpack200
# utility bundled with the JDK.
#

Write-Output "Expand JDK files"
$GetChildItemParameters = @{
    Path = $OracleJDKDirectory;
    Filter = '*.pack';
}
$PackFiles =
    Get-ChildItem @GetChildItemParameters -Recurse

if ($PackFiles)
{
    foreach ($File in $PackFiles)
    {
        $PackFileName =
            $File.FullName
        $JarFileName =
            "$($File.DirectoryName)\$($File.BaseName).jar"

        & "$OracleJDKBinariesDirectory\unpack200" '-r' `
            $PackFileName $JarFileName
    }
}

#
# Create a new SDK directory.
#

$NewItemParameters = @{
    Path = $AndroidSDKDirectory;
    ItemType = 'Directory';
}
New-Item @NewItemParameters -Force | Out-Null

#
# Create a new HOME directory for SDK and configuration files.
#

$NewItemParameters = @{
    Path = $PortableHomeDirectory;
    ItemType = 'Directory';
}
New-Item @NewItemParameters -Force | Out-Null

#
# Tell the Android Studio to search for configuration files
# relative to its current directory.
#

foreach ($Parameter in $AndroidStudioAdditionalParameters)
{
    if (!(Select-String -Pattern $Parameter                   `
                        -Path $AndroidStudioConfigurationFile `
                        -SimpleMatch                          `
                        -Quiet))
    {
        Add-Content -Path $AndroidStudioConfigurationFile `
                    -Value "`n$Parameter"
    }
}

foreach ($VMConfigurationFile in $AndroidStudioVMConfigurationFiles)
{
    foreach ($VMParameter in $AndroidStudioAdditionalVMParameters)
    {
        if (!(Select-String -Pattern $VMParameter      `
                            -Path $VMConfigurationFile `
                            -SimpleMatch               `
                            -Quiet))
        {
            Add-Content -Path $VMConfigurationFile `
                        -Value "`n$VMParameter"
        }
    }
}

#
# Remove temporary files.
#
$aria2RootDirectory = 
    Get-RelativeRootDirectory -RelativePath $aria2Directory
$LessMSIRootDirectory =
    Get-RelativeRootDirectory -RelativePath $LessMSIDirectory
$7zRootDirectory =
    Get-RelativeRootDirectory -RelativePath $7zDirectory

$TemporaryFiles = @(
	$aria2Archive,
    $aria2RootDirectory,
    $LessMSIArchive,
    $LessMSIRootDirectory,
    $7zInstaller,
    $7zRootDirectory,
    $AndroidStudioArchive,
    $OracleJDKInstaller,
    $OracleJDKInternalCAB,
    $OracleJDKInternalArchive
)

$RemoveItemParameters = @{
    Path = $TemporaryFiles;
    ErrorAction = 'SilentlyContinue';
}
Remove-Item @RemoveItemParameters -Recurse -Force

#
# Generate a batch file to start Android Studio.
#

$AndroidSDKBinariesPaths = ''
foreach ($Directory in $AndroidSDKBinariesDirectories)
{
    $AndroidSDKBinariesPaths =
        "%~dp0$Directory;$AndroidSDKBinariesPaths"
}

$AndroidStudioBatchContent = @"
@echo off
REM
REM Starts an instance of Android Studio.
REM
REM This file is automatically generated. Please, do not edit this file.
REM

SET HOMEPATH=%~dp0$PortableHomeDirectory
SET USERPROFILE=%~dp0$PortableHomeDirectory
SET ANDROID_HOME=%~dp0$AndroidSDKDirectory
SET ANDROID_SDK_HOME=%~dp0$PortableHomeDirectory
SET GRADLE_USER_HOME=%~dp0$GradleUserHomeDirectory
SET JAVA_HOME=%~dp0$OracleJDKDirectory

SET PATH=%~dp0$OracleJDKBinariesDirectory;%PATH%
SET PATH=%~dp0$AndroidStudioBinariesDirectory;%PATH%
SET PATH=$AndroidSDKBinariesPaths%PATH%

CHDIR %~dp0$AndroidStudioBinariesDirectory

START $AndroidStudioExecutable
"@

$NewItemParameters = @{
    Path = $AndroidStudioBatchFile;
    Type = 'File';
    Value = $AndroidStudioBatchContent;
}
New-Item @NewItemParameters -Force

#
# The end.
#

Write-Output "`nDone."
