function fix_Matlab2014b_pdf_output(actiondir)
%%% fix Mathworks' pdf output:
% https://www.mathworks.com/matlabcentral/answers/162257-problem-with-patch-graphics-in-2014b-splits-in-two-along-diagonal)
% https://github.com/altmany/export_fig/issues/44
% http://www.mathworks.com/matlabcentral/answers/290313-why-is-vector-graphics-chopped-into-pieces?s_tid=srchtitle
%
%
% Modify this file to suit your needs.
% A. Use shell_script_illustrator_onlyCroppingPaths.sh - selection 1
%    (To remove cropping paths that split up images.)
% B. Use shell_script_illustrator.sh - selection 2
%    (To deal with uniting many paths in a pdf file.)
%
% **NOTE** Running In Batch Mode now - running on all files in dir
%
% 
% Scripts are a little finicky - Matlab is calling a shell script which:
% 1. Loads a file in Illustrator
% 2. Passes a jsx ExtendScript JavaScript file to Illustrator
% 3. Runs that Javascript file
% These steps are done for all files specified, here all the
% files in a directory, input: 'actiondir'.
% 
% I think it's Illustrator that's finicky, but there are so many
% uncontrollable variables in this process it's not possible to pinpoint
% issues or bottlenecks. The only long term solution is to stop using
% Mathworks products.

%%% TO DO:
% 1. UI to Select which fix script
% 2. UI to Select multiple files (batch) mode or single file mode 
% 3. UI to Select operating directory / file (depending on mode)
% 4. Output progress reports and success report on completion.
% 5. Combine two techniques into single pipeline with options.


%%% MODIFY THIS LINE BELOW TO CHANGE FUNCTION
selection = 2;

switch selection
    case 1
        sh_script = 'shell_script_illustrator_onlyCroppingPaths.sh';
        jsx_script = 'fixMatlabPDFOutputOnlyCroppingPaths.jsx';
        % (just cropping paths)
    case 2
        sh_script = 'shell_script_illustrator.sh';
        jsx_script = 'fixMatlabPDFOutput.jsx';
        % (remove cropping paths and group same colored paths)
    otherwise
        display(['unknown selection: ',selection]);
end

startdir = pwd;
P = mfilename('fullpath');
reversestr = fliplr(P);
[justfile, justdirpath] = strtok(reversestr,filesep);
justfile = fliplr(justfile);
base_dir = fliplr(justdirpath);

clc;
txt_filename = [base_dir,filesep,'fix_mat_intro_txt.txt'];
fID = fopen(txt_filename);
info_txt = textscan(fID,'%s','Delimiter','\n');
info_txt=info_txt{1};
for i = 1:length(info_txt)
    fprintf(1,info_txt{i});
    fprintf(1,'\n');
end

fprintf(1,'\n');
display('***!!Discontinue if you did not follow the steps above!!***');
m=input('Do you want to continue, Y/N [Y]:','s');
if any(strcmp(m,{'N','n'}))
    display('aborted.');
    return
end

if (nargin < 1) || isempty(actiondir)
    actiondir = pwd;
end

startdir = pwd;
cd(actiondir);
display(pwd);

pdffiles = dir('*.pdf');
if isempty(pdffiles)
    display('no pdfs found in this location.');
    return
end

for i = 1:length(pdffiles)
    tmpfile = pdffiles(i).name;
    %display(tmpfile);
    tmp_sh_script = [base_dir,filesep,sh_script];
    tmp_jsx_script = [base_dir,filesep,jsx_script];
                 
    display('Running modification script.');
    action_str = ['! ',tmp_sh_script,' ',tmpfile,' ',tmp_jsx_script];
    %display(action_str)
    tic;
    eval(action_str);
    fprintf(1,'\n');
    display('Finished calling mod script from Matlab.');
    display('(...jsx script might still be running in AI.)');
    fprintf(1,'\n');
    display('If the jsx script finished sucessfully you will know by these two things: ');
    display('   1. It saved and closed the pdf file in Adobe Illustrator');
    display('   2. The Output completion confimration text: ''finished running automatingScript_fullFix'' should be shown above.');
    tspan = toc;
    fprintf(1,'\n');
    display(['time to fix all (?) ',num2str(length(pdffiles)),' pdf files: ',num2str(tspan)]);
end