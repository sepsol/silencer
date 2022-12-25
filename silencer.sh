#!/bin/bash

# enable for loops over items with spaces in their name
IFS=$'\n'
 
if [ ! -d converted/ ]; then
	mkdir converted/
fi

for dir in *; do
	if [ ! $dir == "converted" ]; then
		if [ -d "./$dir" ]; then
			cd $dir
     
			read -p "WARNING: this will modify all .mp3 files contained within directories in \"$PWD\", Do you wish to proceed? (y/n)" CONT
	
			if [ "$CONT" == "y" ]; then
    
				echo "adding silence to start and end of .mp3 files in \"$PWD\"." 
				
				if [ ! -d ../converted/$dir ]; then
					mkdir ../converted/$dir
				fi
				
				for i in *.mp3; do
					echo "Converting Input File: \"./$dir/$i\"..."
					sox -V1 "$i" "../converted/$dir/$i" pad 0.4 0.4
					
					if [ $? -eq 0 ]; then
						echo "Successfully converted File \"./$dir/$i\"."
					else
						echo "File \"./$dir/$i\" could not be converted. Aborting!"
						exit 1
					fi
				done
				
				echo "Converted all Files in \"./$dir\"."
				echo -e "\n"
				
				cd ..
				
				echo "SUCCESS! Modified .mp3 files can be found in \"$PWD/converted\"."
			fi 
		else
			echo "ABORTING...";
		fi
	fi
done

exit 0
