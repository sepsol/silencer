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
	Write-Host "Path does not exist."
	Write-Host "ABORTING..."
	Write-Host
	exit 1
}


function Add-Silence {
	Param(
		[System.io.FileInfo]	$file,
		[String]				$modifiedPath,
		[Int]					$fileIndex,		# NOT zero-indexed
		[Int]					$filesCount
	)

	if ($fileIndex -and $filesCount) {
		Write-Host "[$fileIndex/$filesCount] " -ForegroundColor Blue -NoNewLine
	}
	Write-Host """$($file.FullName)""" -ForegroundColor Blue
	Write-Host "`tAdding silence..."

	$inputFile = "$($file.FullName)"
	if ($overwrite -eq $true) {
		$outputFile = "$inputFile"
	} else {
		$outputFile = "$modifiedPath\$($file.Name)"
	}
	
	sox -V1 "$inputFile" "$outputFile" pad $start $end

	if ($?) {
		Write-Host "`tSuccessfully modified the file" -ForegroundColor Green
	} else {
		Write-Host "`tUnable to modify the file" -ForegroundColor Red
	}
	Write-Host

	return $outputFile
}

if ("$path".EndsWith(".mp3")) {
	$file = Get-Item "$path"
	$parentPath = Resolve-Path "$path\.."
	$modifiedPath = "$parentPath\modified"

	if ($overwrite -eq $false) {
		New-Item -ItemType Directory -Force -Path "$modifiedPath"
		Write-Host
	}

	$outputFile = Add-Silence $file $modifiedPath

	Write-Host "SUCCESS!" -ForegroundColor Green
	Write-Host
	Write-Host "To view the modified file open ""$outputFile"""
	Write-Host
} else {
	$files = Get-ChildItem "$path" -Filter *.mp3
	if ($files.Count -gt 0) {
		$modifiedPath = "$path\modified"

		if ($overwrite -eq $false) {
			New-Item -ItemType Directory -Force -Path "$modifiedPath"
			Write-Host
		}
	
		for ($i = 0; $i -lt $files.Count; $i++) {
			$outputFile = Add-Silence $files[$i] $modifiedPath ($i + 1) ($files.Count)
		}
	
		Write-Host "SUCCESS!" -ForegroundColor Green
		Write-Host
		Write-Host "To view the modified file(s) go to ""$(Resolve-Path "$outputFile\..")"""
		Write-Host
	} else {
		Write-Host "Nothing to modify!" -ForegroundColor Yellow
		Write-Host "ABORTING..."
		Write-Host
		exit 1
	}
}
