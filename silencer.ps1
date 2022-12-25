#!/usr/bin/env pwsh

Param(
	[String]	$path 		= ".",
	[Decimal]	$start 		= 0.4,		# seconds
	[Decimal]	$end 		= 0.4,		# seconds
	[Switch]	$overwrite 	= $false
)

Write-Host
Write-Host "Start and end padding set to $($start)s and $($end)s respectively."
Write-Host

$path = Resolve-Path "$path"
if (!$?) {
	Write-Host("Path does not exist.")
	Write-Host("ABORTING...")
	Write-Host
	exit 1
}


function Add-Silence {
	Param(
		[System.io.FileInfo]	$file,
		[String]				$modifiedPath,
		[Int]					$fileIndex 		= 1,	# NOT zero-indexed
		[Int]					$filesCount 	= 1
	)

	Write-Host "[$fileIndex/$filesCount] ""$($file.FullName)""" -ForegroundColor Blue
	Write-Host "`Adding silence..." -ForegroundColor Gray

	$inputFile = "$($file.FullName)"
	if ($overwrite -eq $true) {
		$outputFile = "$inputFile"
	} else {
		$outputFile = "$modifiedPath\$($file.Name)"
	}
	
	sox -V1 "$inputFile" "$outputFile" pad $start $end

	if ($?) {
		Write-Host "`tSuccessfully modified file" -ForegroundColor Green
	} else {
		Write-Host "`tUnable to modify file" -ForegroundColor Red
	}
	Write-Host
}

if ("$path".EndsWith(".mp3")) {
	$file = Get-Item "$path"
	$parentPath = Resolve-Path "$path\.."
	$modifiedPath = "$parentPath\modified"
	New-Item -ItemType Directory -Force -Path "$modifiedPath"
	Write-Host

	Add-Silence $file $modifiedPath

	Write-Host "SUCCESS!" -ForegroundColor Green
	Write-Host
	Write-Host "To view the modified file(s) go to ""$modifiedPath"""
} else {
	$files = Get-ChildItem "$path" -Filter *.mp3
	if ($files.Count -gt 0) {
		$modifiedPath = "$path\modified"
		New-Item -ItemType Directory -Force -Path "$modifiedPath"
		Write-Host
	
		for ($i = 0; $i -lt $files.Count; $i++) {
			Add-Silence $files[$i] $modifiedPath ($i+1) ($files.Count)
		}
	
		Write-Host "SUCCESS!" -ForegroundColor Green
		Write-Host
		Write-Host "To view the modified file(s) go to ""$modifiedPath"""
	} else {
		Write-Host "Nothing to modify!"
		Write-Host "ABORTING..."
		exit 1
	}
}
