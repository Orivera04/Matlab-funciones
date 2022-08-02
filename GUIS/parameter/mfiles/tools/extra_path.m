function extra_path
udir = 'units';
if exist(udir,'dir')
   udir = [pwd '\units'];
   A = dir('units');
   for i=3:length(A)
      if (A(i).isdir)
         addpath(fullfile(udir,A(i).name),'-end')
      end
   end
   addpath('tools','-end')
else
   disp('Change to ''mfiles'' folder and try again')
end