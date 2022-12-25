# Silencer
The scripts in this repository leverage [SoX](http://sox.sourceforge.net/) to add `300 ms` of silence to the beginning and `100 ms` of silence to the end of an existing `.mp3` file.

All converted files will be in the new subdirectory `converted` inside the directory where this script is executed; the original files will remain untouched.

## Usage

```
silencer [start(s)] [end(s)] [path]
```

## Installing dependancies
The scripts in this repository depend on [SoX](http://sox.sourceforge.net/), a cross-platform (Windows, Linux, MacOS X, etc.) command line utility to manipulate audio files.

### Windows
1. Run the command below to install SoX:

	```cmd
	winget install sox
	```

2. Add the path of the `sox.exe` executable to Windows Path environment variable by running the command below in Command Prompt:

	```cmd
	setx Path "%Path%;%ProgramFiles(x86)%\sox-14-4-2"
	```

	Now, the `sox` command should work inside your terminal.

3. Then, for SoX to be able to work with mp3 file format, you need to grab a couple of files. Go to [this URL](https://app.box.com/s/tzn5ohyh90viedu3u90w2l2pmp2bl41t) and download the Zip file.
	<!-- Download link from https://stackoverflow.com/questions/3537155/sox-fail-util-unable-to-load-mad-decoder-library-libmad-function-mad-stream -->

	Extract the Zip file and move `libmad-0.dll` and `libmp3lame-0.dll` files to the directory where your `sox.exe` file is located.

### Linux
1. Run the command below to install SoX:

	```sh
	sudo apt update && sudo apt install sox
	```

	Now, the `sox` command should work inside your terminal.

2. Then, for SoX to be able to work with mp3 file format, you need to install an additional library package by running the command below:

	```sh
	sudo apt install libsox-fmt-mp3
	```

### macOS
_TODO_

## Credits
The bash script in this package is a fork of [`add-silence-to-mp3`](https://github.com/lubomski/add-silence-to-mp3) repository by [Richard Lubomski](https://github.com/lubomski).