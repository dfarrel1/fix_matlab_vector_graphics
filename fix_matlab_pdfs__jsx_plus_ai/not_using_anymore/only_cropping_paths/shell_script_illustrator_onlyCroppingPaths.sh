
#!/bin/bash
### find this file 
export this_file_dir=`dirname $BASH_SOURCE`
echo -e '\nlocation of current script: '$this_file_dir

### get the Illustrator Application location
# if [ "$#" -ne 2 ] || ! [ -d "$2" ]; then
# 	echo "Usage: $0 <illustrator-app-location> <pdf-file>" >&2
# 	echo -e '\nDrag Illustrator into Terminal, then hit Enter'
# 	read appname
# else
# 	export appname=$2
# fi

### get the pdf file location
if [ "$#" -lt 1 ] || ! [ -f "$1" ]; then
	echo "Usage: $0 <pdf-file>" >&2
	echo -e '\nDrag file into Terminal, then hit Enter'
	read file2mod
else
	export file2mod=$1
fi

##default_app = '/Applications/Adobe\ Illustrator\ CS6/Adobe\ Illustrator.app'

echo 'OPENING FILE IN ILLUSTRATOR'
open -a /Applications/Adobe\ Illustrator\ CS6/Adobe\ Illustrator.app $file2mod

#read -p "Do you wish to run the javascript file,"$this_file_dir"/fixMatlabPDFOutput.jsx ?" yn
#case $yn in
#    [Yy]* ) echo 'continuing';;
#    [Nn]* ) exit;;
#esac


### NEED TO CHANGE IF NOT A MAC
echo 'RUNNING JAVASCRIPT ON FILE'
osascript $this_file_dir'/automatingScript_fixOnlyCroppingPaths.scpt'