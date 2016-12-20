# Fixing Matlab Output

## Overview
Contained within are two separate workarounds for fixing Matlab vector graphics output (eps, pdf). They both unite objects of the same color that Matlab fractures when exporting.

The first is a jsx javascript hack. This will only work on Macs as is. You will need to edit it to get it to work on a Windows machine. I dont' know if it's possible to use this jsx fix on Linux. 

The second is a fix created by [Sven Baars](https://github.com/Sbte "Sven Baars") with a python script that uses Inkscape. I packaged it with my own for convenience and I've added install instructions for Mac users and a couple other useful matlab functions.

The .jsx script solution works better in creating the final vector graphics that I want, but it's very slow, and sometimes Illustrator and ExtendScript Toolkit need to be restarted. If you can get the result you want from fix_matlab_eps.py, then that's the one to use.

## 1. fix_matlab_pdfs__jsx_plus_ai
Runnable function from Matlab:
fix_Matlab2014b_pdf_output.m

**Description**  
fix_Matlab2014b_pdf_output.m fixes Matlab pdf output issues that exist for all Matlab versions 2014b and later.

REQUIREMENTS:

- Adobe Illustrator
- Mac OS

You will need to edit the shell_script_illustrator.sh file.
The line of code under the commented line that reads (around line 21):  
``` 
 '### NEED TO MODIFY if Illustrator is installed to a different location'  
 ```
 will need to be modified if the location of Adobe Illustrator is different on your machine.
 
e.g. change this:  
```
export appname="/Applications/Adobe Illustrator CS6/Adobe Illustrator.app"
```
to this:  
 ```
export appname="<path-to-illustrator-on-your-computer>"
```


		  Pipeline: [Going from Top to Bottom]
			 	 	  			 	 	  
-	      (Matlab) fix_Matlab2014b_pdf_output.m    
    
-	      (bash script) shell_script_illustrator.sh    
					  
-	      (Adobe Illustrator) [loading file and running jsx script]  
	      			 
-	      (ExtendScript Toolkit) fixMatlabPDFOutput.jsx
	      			 
-	      (Adobe Illustrator) emulating actions described in jsx script
	      			
If you edit the .jsx script I suggest using any IDE other than the default ExtendScript Toolkit App, e.g. IntelliJ IDEA or Eclipse.

*For Windows Users - the steps done in the bash script need to be replaced with something else, something that talks to Adobe Illustrator. I think you can still run the jsx script from Windows, but you need to figure out how to feed it to Adobe Illustrator from the commandline.*

The whole process works best if you startout with Adobe Illustrator and ExtendScript Toolkit closed. For me, it works fairly quickly for pdf files that have been fractured into less than 2000 path objects and it starts to really have some trouble with pdfs that have been split up into more than 10K path objects.

Each step in the pipeline works without doing the preceeding steps if you don't want to use Matlab as the origin of the process. You can run the bash script from a terminal. You can open a file in illustrator and run the .jsx script without doing any of the preceeding steps.
Illustrator -> File -> Scripts -> Other Scripts -> Select fixMatlabPDFOutput.jsx.

It can be useful for testing to start closest to the bottom of the pipeline and work your way back to the top.

##2. fix_matlab_eps.py
Originally from (https://github.com/Sbte/fix_matlab_eps)
and included here for convenvience. 

**Description**
 
A Python script to fix artifacts in EPS files generated from Matlab contour plots. These artifacts are white lines that have been present since Matlab 2014b.

**Requirements**  
- Inkscape  
- Python.  

For Mac users there are a few extra steps that I'm listing here:

1. After following all install instructions for Inkscape and XQuartz it was necessary for me to create a symlink for Inkscape in the PATH: 
 
	```
ln -s /Applications/Inkscape.app/Contents/Resources/bin/inkscape   /usr/local/bin/inkscape
```  

	(and be sure to link 'inkscape' not 'inkscape-bin')  
	(http://stackoverflow.com/questions/22085168/inkscape-command-line-where-is-it-on-mac)

2. When testing python code that calls inkscape, specify full paths of image and vector files being loaded.  
(https://bugs.launchpad.net/inkscape/+bug/1449251)

3. Add '/usr/local/bin/' to the PATH in matlab  
(https://www.mathworks.com/help/matlab/matlab_external/run-external-commands-scripts-and-programs.html)  

	```
path1 = getenv('PATH')  
path1 = [path1 ':/usr/local/bin']  
setenv('PATH', path1)  
!echo $PATH     
```  

4. Repair libtiff library (this might have been specific to my machine)
(https://github.com/kyamagu/mexopencv/issues/250) [at bottom]  

	This is what I did:  
backed up original file to: /Applications/MATLAB_R2016a.app/bin/maci64/  backup_libtiff.5.dylib  
simlinked from: /usr/local/opt/libtiff/lib/libtiff.5.dylib

5. install ghostscript  
http://brewformulas.org/Ghostscript

6. You should be able to run fix_matlab_eps.py now.  
For Example see ./fix_matlab_eps/image_output_scratchpad.m


**Example (for fix_matlab_eps.py)**

Here is an example of what the EPS looks like before and after my script.  
The EPS was created by

```
%%% Matlab Code
z = peaks;
contourf(z);
print(gcf,'-depsc','-painters','out.eps');
```

![Before and After](http://i.imgur.com/8pp5JYt.png)

##3. Also Included  

eps2pdf.m  
(https://www.mathworks.com/matlabcentral/fileexchange/5782-eps2pdf/content/eps2pdf.m)

fix_2016a_figure_output.m
A short matlab script that fixes clipping of figure exports in Matlab version 2016a and above. Related to the 'PaperPosition' property.  

** Full Directory Tree **  

```
.
├── LICENSE
├── README.md
├── extras
│   ├── eps2pdf-license.txt
│   ├── eps2pdf.m
│   ├── fix_2016a_figure_output.m
│   └── testing_viewers.xlsx
├── fix_matlab_eps_py_plus_inkscape
│   ├── Instructions_for_running_fix_matlab_eps.txt
│   ├── fix_matlab_eps.py
│   ├── image_output_scratchpad.m
│   └── image_output_scratchpad.m~
├── fix_matlab_pdfs__jsx_plus_ai
│   ├── automatingScript_fullFix.scpt
│   ├── fixMatlabPDFOutput.jsx
│   ├── fix_Matlab2014b_pdf_output.m
│   ├── fix_mat_intro_txt.txt
│   ├── not_using_anymore
│   │   ├── only_cropping_paths
│   │   │   ├── automatingScript_fixOnlyCroppingPaths.scpt
│   │   │   ├── fixMatlabPDFOutputOnlyCroppingPaths.jsx
│   │   │   └── shell_script_illustrator_onlyCroppingPaths.sh
│   │   └── sandbox_files
│   │       ├── sandbox_01.html
│   │       └── sandbox_01.js
│   └── shell_script_illustrator.sh
└── test-imgs
    ├── fixed
    │   ├── peaks_jsx_fix.pdf
    │   └── peaks_py_fix.pdf
    └── original
        ├── peaks.eps
        └── peaks.pdf
```
