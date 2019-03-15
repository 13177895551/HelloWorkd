# @@@+++@@@@******************************************************************
# **
# ** Copyright (c) Microsoft Corporation. All rights reserved.
# **
# @@@+++@@@@******************************************************************
# 
# Update the version name prefix such as 2.6.2

param(
    [string]$newVersionNamePrefix = ""
)

Set-PSDebug -Strict
Set-StrictMode -Version 2.0

if (-Not($newVersionNamePrefix -cmatch '^\d+\.\d+\.\d+$')) {
    Write-Host $newVersionNamePrefix "is invalid version name prefix, e.g. 1.2.3 is a valid one."
    exit 1
}

$oldVersionNamePrefix = Get-Content $env:BUILD_VERSIONNAMEPREFIXFILE
Set-Content $env:BUILD_VERSIONNAMEPREFIXFILE $newVersionNamePrefix
Set-Content $env:BACKUP_VERSIONNAMEPREFIXFILE $oldVersionNamePrefix
