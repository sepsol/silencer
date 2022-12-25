#!/usr/bin/env pwsh

Param(
	$path = ".",
	$start = 0.3,	# seconds
	$end = 0.1		# seconds
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


if ("$path".EndsWith(".mp3")) {
	$parentPath = Resolve-Path "$path\.."
	$modified = "$parentPath\modified"
	New-Item -ItemType Directory -Force -Path "$modified"
	Write-Host
	
	$file = Get-Item "$path"

	Write-Host "[1/1] ""$($file.FullName)""" -ForegroundColor Cyan
	Write-Host "`Adding silence..." -ForegroundColor Gray
	sox "$($file.FullName)" "$modified\$($file.Name)" pad $start $end

	if ($?) {
		Write-Host "`tSuccessfully modified file" -ForegroundColor Green
	} else {
		Write-Host "`tUnable to modify file" -ForegroundColor Red
	}
	Write-Host

	Write-Host "SUCCESS!" -ForegroundColor Green
	Write-Host
	Write-Host "To view the modified file(s) go to ""$modified"""
} else {
	$files = Get-ChildItem "$path" -Filter *.mp3
	
	if ($files.Count -gt 0) {
		$modified = "$path\modified"
		New-Item -ItemType Directory -Force -Path "$modified"
		Write-Host
	
		for ($i = 0; $i -lt $files.Count; $i++) {
			$file = $files[$i]
			Write-Host "[$($i + 1)/$($files.Count)] ""$($file.FullName)""" -ForegroundColor Cyan
			Write-Host "`tAdding silence..." -ForegroundColor Gray
			sox -V1 "$($file.FullName)" "$modified\$($file.Name)" pad $start $end
	
			if ($?) {
				Write-Host "`tSuccessfully modified file" -ForegroundColor Green
			} else {
				Write-Host "`tUnable to modify file" -ForegroundColor Red
			}
			Write-Host
		}
	
		Write-Host "SUCCESS!" -ForegroundColor Green
		Write-Host
		Write-Host "Modified all $($files.Count) .mp3 file(s) in ""$path"""
		Write-Host "To view the modified file(s) go to ""$modified"""
	} else {
		Write-Host "Nothing to modify!"
		Write-Host "ABORTING..."
		exit 1
	}
}
