Scripts to make Android Studio portable
=======================================

Here you can find a number of PowerShell scripts to make Android Studio
portable. To run the scripts you need PowerShell version 2.0 or higher.

* __Setup-AndroidStudioPortable.ps1__

	+ Downloads aria2 and unpacks its archive.
    + Downloads 7zr to bootstrap extraction of 7-zip archives
    + Downloads 7-Zip and unpacks its installer with 7zr.
    + Downloads Android Studio and unpacks its archive.
    + Generates a batch file to start an Android Studio instance without
      PowerShell.

* __Start-AndroidStudioPortable.ps1__

    + Sets environment variables relative to the current directory.

        - `HOMEPATH` (_~\_)
        - `USERPROFILE` (_~\_)
        - `ANDROID_HOME` (_Android SDK root_)
        - `ANDROID_SDK_HOME` (_~\\.android_)
        - `GRADLE_USER_HOME` (_~\\.gradle_)

    + Adds directories with executables from the SDK at the beginning
      of the `PATH` environment variable for use in the Android Studio
      terminal.

        - Android Studio _bin_ directory
        - Android SDK _tools_ and _platform-tools_ directories

* __Remove-SetupTemporaryFiles.ps1__

    + Removes all aria2 and 7-Zip files then Studio archive.
		
* __Remove-AndroidStudioPortable.ps1__

    + Removes all aria2 and 7-Zip files then Studio archive.
    + Removes the unpacked SDK and Studio directories but leaves the
      portable home directory along.

* __AndroidStudioPortable-Definitions.ps1__

    + Contains definitions for URLs, file/directory names, and parameters used
      by other scripts.
    + Can be modified to install a different version of a certain package.

* __AndroidStudioPortable-Helpers.ps1__

    + Contains helper functions and shims to support old PowerShell versions.

## Shortcomings

* The scripts don't touch your project files in any way or form. That means you
  will have to update the path to the Android SDK directory in
  your project settings from time to time.

* In an environment with a `Restricted` PowerShell execution policy you have to
  start scripts in the following way

        PowerShell.exe -ExecutionPolicy Bypass -File <a script file name to start>

* Network (or UNC) paths are not supported.

* SD card and skin paths for AVDs are not automatically updated.
