function uninstall(pddir)
%UNINSTALL  Uninstall toolbox directories.
%   UNINSTALL is an easy to use uninstallation program for toolboxes.
%   It uninstalls toolbox directories when run from the base directory
%   of a toolbox. A file "info.ins" created by MAKEINSTALL must exist
%   in this directory.
%   Example of usage:
%
%      » cd(fullfile(matlabroot,'toolbox','digitalsim'))
%      » disp(pwd)
%      C:\MATLAB\toolbox\digitalsim
%      » uninstall
%      Uninstalled.
%      »
%
%   If you are sharing matlab over a network, the location of the
%   'pathdef.m' file might have to be specified:
%   UNINSTALL PDDIR
%   In the example above, we could instead write:
%
%      » uninstall C:\MATLAB\toolbox\local\
%
%   Alternatively, you can write:
%   UNINSTALL -
%   which will bring up an file selection menu where you choose the
%   pathdef.m file you want UNINSTALL to update.
%
%   See also INSTALL, MAKEINSTALL, CHECKINSTALL.

% Copyright (c) 2003-07-15, B. Rasmus Anthin.
% Revision 2003-07-16, 2003-07-17, 2003-07-22.

if ~exist(fullfile(pwd,'info.ins'),'file')
   error('This toolbox cannot be uninstalled.')
end
load info.ins -mat
if ~IS_INSTALLED
   warning('This toolbox is already uninstalled.')
end
rmpath(pwd)
for i=1:length(INS_DIRS)
   rmpath(fullfile(pwd,INS_DIRS{i}))
end
if ~nargin
   flag=path2rc;
elseif strcmp(pddir,'-')
   [fname,pname]=uigetfile('pathdef.m','Choose ''pathdef.m'' to update.');
   flag=path2rc(fullfile(pname,fname));
else
   flag=path2rc(fullfile(pddir,'pathdef.m'));
end
switch(flag)
case 1, error('Path could not be saved to pathdef.m. Try "uninstall -".')
case 2, error('Original pathdef.m was not found. Try "uninstall -".')
case 3, error('Original pathdef.m was found but couldn''t be read. Try "uinstall -".')
end
disp('Uninstalled.')
IS_INSTALLED=0;
save info.ins INS_DIRS IS_INSTALLED