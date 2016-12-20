#!/bin/bash
# <shell_script_illustrator> <pdf-file> <jsx-file> <ai-app>
# takes as input:
# <pdf-file>: the pdf file to change
# <jsx-file>: the jsx script used to modify it
# both should be given as full paths


### find this file
export short_nm='shell2call_ai.sh'
export this_file_dir=`dirname $BASH_SOURCE`
echo -e '\nlocation of current script: '$this_file_dir



### get the Illustrator Application location
if [ "$#" -lt 3 ] || ! [ -d "$3" ]; then
    echo -e "\nUsage: $short_nm <pdf-file> <jsx-file> <ai-app>" >&2
    echo -e 'using default location of Illustrator'

    ### NEED TO MODIFY if Illustrator is installed to a different location
    export appname="/Applications/Adobe Illustrator CS6/Adobe Illustrator.app"
    echo -e 'default app location: '$appname
else
    export appname=$3
fi


### default for .jsx script
if [ "$#" -lt 2 ]; then
    echo -e "\nUsage: $short_nm <pdf-file> <jsx-file> <ai-app>" >&2
    echo -e "\nUsing full fix script\n"
    export jsx_script_fname=$this_file_dir'/fixMatlabPDFOutput.jsx'
else
    export jsx_script_fname=$2
fi

### check that .jsx script exists
export jsx_full_fname=$jsx_script_fname
if [ -f $jsx_full_fname ]; then
    echo "--->jsx_full_fname found."
else
    echo -e "\njsx_full_fname: "$jsx_full_fname
    echo "--->jsx_full_fname not found."
    exit 1
fi


### get the pdf file location
if [ "$#" -lt 1 ] || ! [ -f "$1" ]; then
	echo -e "\nUsage: $short_nm <pdf-file> <jsx-file> <ai-app>" >&2
	echo -e '\nDrag PDF file into Terminal, then hit Enter'
	read file2mod
else
	export file2mod=$1
fi


echo -e '\nOPENING FILE IN ILLUSTRATOR'
open -a "$appname" $file2mod



echo -e '\nRUNNING JAVASCRIPT ON FILE\n'
### NEED TO CHANGE IF NOT A MAC
### RUN from AppleScript (no longer using applescript)
#osascript $this_file_dir'/automatingScript_fullFix.scpt' $jsx_full_fname
#exit 1

### RUN the applescript that calls the jsx script right here:
osascript <<EOF
tell application "Adobe Illustrator"
    do javascript "#include $jsx_full_fname"
end tell
EOF
