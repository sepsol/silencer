#!/usr/bin/env pwsh

Param(
	$path = ".",
	$start = 0.3,	# seconds
	$end = 0.1		# seconds
)
Write-Host "Padding with $($start)s at start and $($end)s at end."

$path = Resolve-Path "$path"
if (!$?) {
	Write-Host
	Write-Host("Path does not exist.")
	Write-Host("ABORTING...")
	Write-Host
	exit 1
}


if ("$path".EndsWith(".mp3")) {
	$converted = Resolve-Path "$path\..\converted"
	New-Item -ItemType Directory -Force -Path "$converted"
	Write-Host
	
	$file = Get-Item "$path"

	Write-Host "[1/1] ""$($file.FullName)""" -ForegroundColor Blue
	Write-Host "`tConverting file..." -ForegroundColor Gray
	sox "$($file.FullName)" "$converted\$($file.Name)" pad $start $end

	if ($?) {
		Write-Host "`tSuccessfully converted file" -ForegroundColor Green
	} else {
		Write-Host "`tUnable to convert file" -ForegroundColor Red
	}
	Write-Host

	Write-Host "SUCCESS!" -ForegroundColor Green
	Write-Host
	Write-Host "Modified .mp3 file(s) can be found in ""$converted"""
} else {
	$files = Get-ChildItem "$path" -Filter *.mp3
	
	if ($files.Count -gt 0) {
		$converted = Resolve-Path "$path\converted"
		New-Item -ItemType Directory -Force -Path "$converted"
		Write-Host
	
		for ($i = 0; $i -lt $files.Count; $i++) {
			$file = $files[$i]
			Write-Host "[$($i + 1)/$($files.Count)] ""$($file.FullName)""" -ForegroundColor Blue
			Write-Host "`tConverting file..." -ForegroundColor Gray
			sox "$($file.FullName)" "$converted\$($file.Name)" pad $start $end
	
			if ($?) {
				Write-Host "`tSuccessfully converted file" -ForegroundColor Green
			} else {
				Write-Host "`tUnable to convert file" -ForegroundColor Red
			}
			Write-Host
		}
	
		Write-Host "SUCCESS!" -ForegroundColor Green
		Write-Host
		Write-Host "Converted all $($files.Count) .mp3 file(s) in ""$path"""
		Write-Host "Modified .mp3 file(s) can be found in ""$converted"""
	} else {
		Write-Host "Nothing to convert!"
		Write-Host "ABORTING..."
		exit 1
	}
}
