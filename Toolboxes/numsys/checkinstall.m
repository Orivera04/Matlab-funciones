function checkinstall
%CHECKINSTALL  Checks toolbox installation info.
%   Prettyprints the directories that are to be installed in the
%   matlab path when running the INSTALL program, or uninstalled 
%   from the matlab path when running UNINSTALL. The last line shows
%   whether the toolbox is installed or not.
%
%   See also MAKEINSTALL, INSTALL, UNINSTALL.

% Copyright (c) 2003-07-15, B. Rasmus Anthin.
% Revision 2003-07-16.

if ~exist(fullfile(pwd,'info.ins'),'file')
   error('Installation info is missing. Wrong directory?')
end
load info.ins -mat
disp(' ')
disp([blanks(3) pwd])
for i=1:length(INS_DIRS)
   disp([blanks(3) fullfile(pwd,INS_DIRS{i})])
end
if IS_INSTALLED
   disp([blanks(3) 'Installed.'])
else
   disp([blanks(3) 'Not installed.'])
end
disp(' ')