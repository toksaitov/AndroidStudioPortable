#
# Remove temporary files.
#
$aria2RootDirectory = 
    Get-RelativeRootDirectory -RelativePath $aria2Directory

$TemporaryFiles = @(
	$aria2Archive,
    $aria2RootDirectory,
    $7zBootStrapExec,
    $7zInstaller,
    $7zExecutable,
    $AndroidStudioArchive,
    $OracleJDKInstaller,
	$OracleJDKInternalArchive
)

$RemoveItemParameters = @{
    Path = $TemporaryFiles;
    ErrorAction = 'SilentlyContinue';
}
Remove-Item @RemoveItemParameters -Recurse -Force