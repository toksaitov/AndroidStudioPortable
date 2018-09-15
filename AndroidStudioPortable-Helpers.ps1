#Requires -Version 2.0

<#
    .SYNOPSIS
        Helper functions and shims for older versions of PowerShell
 #>

<#
    .SYNOPSIS
        Expands a relative path into an absolute path.
 #>

function Expand-Path
{
    [OutputType([String])]
    Param (
        [Parameter(Mandatory=$true)]
        [String]
        $Path
    )

    $ResolvePathParameter = @{
        Path = $Path;
        ErrorAction = 'SilentlyContinue';
        ErrorVariable = 'ResolveError';
    }
    $ResolvedPath =
        Resolve-Path @ResolvePathParameter

    if (!($ResolvedPath))
    {
        $ResolvedPath =
            $ResolveError[0].TargetObject
    }

    return "$ResolvedPath"
}

<#
    .SYNOPSIS
        Returns the first directory name in a relative path.
 #>

function Get-RelativeRootDirectory
{
    [OutputType([String])]
    Param(
        [Parameter(Mandatory=$true)]
        [String]
        $RelativePath
    )

    $Path =
        Expand-Path -Path $RelativePath
    $RelativePath =
        $Path.Replace($PWD, '')

    $Elements =
        $RelativePath.Split('\')
    $Directory =
        $Elements[0]

    if (!($Directory))
    {
        $Directory =
            $Elements[1]
    }

    return $Directory
}

<#
    .NOTES
        An `Expand-Archive` shim for older PowerShells
 #>

if (!(Get-Command -Name 'Expand-Archive' `
                  -ErrorAction SilentlyContinue))
{
    $ExpandArchiveIsShimmed =
        $true

    <#
        .SYNOPSIS
            Unpacks an archive.
    #>
    function Expand-Archive
    {
        Param(
            [Parameter(Mandatory=$true)]
            [String]
            $Path
        )

        if (Test-Path -Path $Path)
        {
            $Path =
                Expand-Path -Path $Path

            $NewObjectParameters = @{
                TypeName = 'System.IO.FileInfo';
                ArgumentList = $Path;
            }
            $DestinationDirectoryInfo =
                New-Object @NewObjectParameters
            $DestinationDirectory =
                ".\$($DestinationDirectoryInfo.BaseName)"
            $DestinationDirectory =
                Expand-Path -Path $DestinationDirectory

            $NewItemParameters = @{
                Path = $DestinationDirectory;
                ItemType = 'Directory';
            }
            New-Item @NewItemParameters -Force | Out-Null

            $ShellApplication =
                New-Object -Com 'shell.application'

            $Archive =
                $ShellApplication.NameSpace($Path)
            $Destination =
                $ShellApplication.NameSpace($DestinationDirectory)

            $Destination.CopyHere($Archive.Items())
        }
    }
}

function Invoke-FileDownload
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [uri] $Uri,

        [Parameter(Mandatory)]
        [string] $OutFile,
		
		[Parameter(Mandatory=$false)]
        [System.Net.CookieContainer]
        $Cookies
    )

    $webClient = New-Object System.Net.WebClient

    $changed = Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -Action {
        Write-Progress -Activity "Downloading...." -PercentComplete $eventArgs.ProgressPercentage -Status "Downloaded $($([System.Math]::Floor($eventArgs.BytesReceived/1048576)))M of $($([System.Math]::Floor($eventArgs.TotalBytesToReceive/1048576)))M"
	}

	if($Cookies){
		$Header =
            $Cookies.GetCookieHeader($Uri)

        $webClient.Headers.Add('Cookie', $Header)
	}
	
    $handle = $webClient.DownloadFileAsync($Uri, $PSCmdlet.GetUnresolvedProviderPathFromPSPath($OutFile))

    while ($webClient.IsBusy)
    {
        Start-Sleep -Milliseconds 10
    }

    Write-Progress -Activity "Downloaded $($Uri) to $($OutFile)" -Completed
    Remove-Job $changed -Force
    Get-EventSubscriber | Where SourceObject -eq $webClient | Unregister-Event -Force
}
