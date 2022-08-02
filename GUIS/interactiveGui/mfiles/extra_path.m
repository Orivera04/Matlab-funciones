function extra_path
if ~exist('unit_length')
    disp('this example requires that this folder and subfolder are in the path')
    disp('for this example this is done now automatically.')
end
udir = 'units';
if exist(udir,'dir')
   allunits=genpath(fullfile(pwd,'units'));
   addpath(allunits,'-end');
   addpath('tools','-end');
else
   disp('Change to ''mfiles'' folder and try again')
end