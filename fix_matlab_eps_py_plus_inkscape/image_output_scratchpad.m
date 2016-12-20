function image_output_scratchpad()
%%% trying to fix matlabs pdf/eps output
%%% using (https://github.com/Sbte/fix_matlab_eps)
%%% run this from the directory that you want to save the images in
%%% file is for testing code / for demo use
%%% build your own function for production use

P = mfilename('fullpath');
base_dir = fileparts(P);
cd(base_dir);

test_dir = [base_dir,filesep,'test_imgs',filesep];
if ~isdir(test_dir)
    mkdir(test_dir);
end

figure;
[X,Y,Z] = peaks(100);
[~,ch] = contourf(X,Y,Z);
ch.LineStyle = 'none';
ch.LevelStep = ch.LevelStep/10;
colormap('hot')
imgSvNm = 'peaks';
print(gcf,[test_dir,imgSvNm],'-depsc2')
print(gcf,[test_dir,imgSvNm],'-dpdf')

% figure;
% z = peaks;
% contourf(z);
% imgSvNm = 'out';
% print(gcf,'-depsc','-painters',[test_dir,imgSvNm,'.eps']);
% print(gcf,[test_dir,imgSvNm],'-dpdf');



fname_in = [test_dir,imgSvNm,'.eps'];
fname_out = [test_dir,imgSvNm,'_fixed.eps'];
system(['python fix_matlab_eps.py ',fname_in,' ',fname_out]);
eps2pdf(fname_out,'/usr/local/bin/gs',1);

return

%%%%%% copy-paste stuff
path1 = getenv('PATH');
path1 = [path1 ':/usr/local/bin'];
setenv('PATH', path1)
full_path = '/Users/denefarrell/SRC/Matlab/zlab_codebase/Dene/active/miscellaneous/fix_image_output';
fname_input = [full_path,'/peaks.eps'];
fname_output = [full_path,'/peaks_fixed.eps'];
system(['python fix_matlab_eps.py ',fname_input,' ',fname_output]);