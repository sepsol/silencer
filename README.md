# Silencer
The scripts in this repository leverage [SoX](http://sox.sourceforge.net/) to add (by default) `400 ms` of silence to the beginning and `400 ms` of silence to the end of existing .mp3 file(s).

All converted files will be in the new subdirectory `converted` inside the directory where this script is executed; the original files will remain untouched.

## Usage

```
silencer [path] [start(s)] [end(s)]
```

## Why?
If you've ever tried to use a bluetooth headphone to listen to a short sound (like a pronounciation of a word) being played from your device, you know that the beginning of the audio gets cut during transmition. That is by design since the bluetooth headphones go into sleep to preserve battery and when you want to play an audio file, there'll be a small lag before they connect back to your device and play the sound.

The added silence by the scripts in this repository, help resolve this issue by giving your headphones a couple of more seconds of silence before playing the important part of your audio file.

## Before you run the scripts
The scripts in this repository depend on [SoX](http://sox.sourceforge.net/), a cross-platform (Windows, Linux, MacOS X, etc.) command line utility to manipulate audio files.

#### Windows
1. Run the command below to install SoX:

	```pwsh
	winget install sox
	```

2. Add the path of the `sox.exe` executable to Windows Path environment variable by running the command below:

	```pwsh
	cmd /c 'setx Path "%Path%;%ProgramFiles(x86)%\sox-14-4-2"'
	```

	Now, the `sox` command should work inside your terminal.

3. Then, for SoX to be able to work with mp3 file format, you need to grab a couple of files. Go to [this URL](https://app.box.com/s/tzn5ohyh90viedu3u90w2l2pmp2bl41t) and download the Zip file.
	<!-- Download link from https://stackoverflow.com/questions/3537155/sox-fail-util-unable-to-load-mad-decoder-library-libmad-function-mad-stream -->

	Extract the Zip file and move `libmad-0.dll` and `libmp3lame-0.dll` files to the directory where your `sox.exe` file is located.

4. Finally, download the `.ps1` script in this repository and put it somewhere in your computer like `%UserProfile%`. Then, edit your profile by running `notepad $profile` and paste this line there:

	```pwsh
	# $profile
	Set-Alias -Name silencer -Value "$env:UserProfile\silencer.ps1"
	```

	Now, source your shell by calling `. $profile` to apply the changes. After that, you should be able to call `silencer` from your terminal.

#### Linux
1. Run the command below to install SoX:

	```sh
	sudo apt update && sudo apt install sox
	```

	Now, the `sox` command should work inside your terminal.

2. Then, for SoX to be able to work with mp3 file format, you need to install an additional library package by running the command below:

	```sh
	sudo apt install libsox-fmt-mp3
	```

3. Finally, download the `.sh` script in this repository and put it somewhere in your computer like `~`. Then, modify your profile by calling `nano ~/.bashrc` and paste this line there:

	```sh
	# ~/.bashrc
	alias='bash ~/silencer.sh'
	```

	Now, source your shell by calling `. ~/.bashrc` to apply the changes. After that, you should be able to call `silencer` from your terminal.

#### macOS
_TODO_

## Credits
The bash script in this package is a fork of [`add-silence-to-mp3`](https://github.com/lubomski/add-silence-to-mp3) repository by [Richard Lubomski](https://github.com/lubomski).