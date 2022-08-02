function mbcconfig(mode)
%MBCCONFIG MBC Toolbox Configuration Tool
%
%  MBCCONFIG -SETUP installs system files needed by MBC Toolbox on local
%  machine.
%
%    This function is provided as a way to update the system files from
%    MATLAB  so that you don't need to run the installer.  This is useful
%    for sites  that have one central MATLAB installation instead of
%    installing MATLAB  locally on each machine.
%
%    To update system files on local machine: mbcconfig -setup   -or-
%    mbcconfig('-setup')
%
%  MBCCONFIG -ADDON starts the MBC Toolbox Add-On Manager 
%   
%    To add/remove an MBC Add-On: mbcconfig -addon   -or-
%    mbcconfig('-addon')
%
%  See also MBCMODEL, CAGE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.14.4.3 $  $Date: 2004/04/04 03:25:46 $

% Argument checking
if (nargin ~= 1)
   error([ sprintf('\n') 'mbcconfig -setup   :   Update system files on local machine' sprintf('\n') ...
         'mbcconfig -addon   :   Start the MBC Toolbox Add-On Manager']); 
end

if (nargout ~= 0)
   error('Incorrect number of outputs.  This function has no outputs.');
end

% Make sure we are on a PC
if ~ispc
   error('This function only runs on Windows.');
end

% If setup mode install system files
if strcmpi(mode, '-setup') 
   % This code assumes that all the files to install will always be
   % in the ocx directory in mbcguitools.
   ocxdir = mbcocxpath;
   systemocxdir = fullfile(ocxdir, 'system');
   
   % This is the complete list of files to be installed.  
   % Note the order here is the order they will be installed, 
   % so any dependencies are reflected here.
   % (msvbvm60.dll should be installed first)
   
   % System dll's
   sDir = dir(fullfile(systemocxdir, '*.dll'));
   % System ocx's
   sDir = [sDir; dir(fullfile(systemocxdir, '*.ocx'))];
   
   filelist = cell(size(sDir));
   for n = 1:length(sDir)
       filelist{n} = fullfile(systemocxdir, sDir(n).name);
   end
   % Call the local function to do the installation
   status = localInstallFiletoSystemDir(filelist, true);
   
   % Custom dll's
   cDir = dir(fullfile(ocxdir, '*.dll'));
   % Custom ocx's
   cDir = [cDir; dir(fullfile(ocxdir, '*.ocx'))];
   
   filelist = cell(size(cDir));
   for n = 1:length(cDir)
       filelist{n} = fullfile(ocxdir, cDir(n).name);
   end     
   % Call the local function to do the installation
   status = [status localInstallFiletoSystemDir(filelist, false)];
   
   if all(status == 1)
      disp('Installation successful.');
   end

% If setup mode addon extras
elseif strcmpi(mode, '-addon') 
    i_addon;

else
   error('Unexpected input value.');
end




% localInstallFiletoSystemDir Call mex file to do the actual file update
% and registry modifications.
% Inputs: filelist cell array of full path and name of files to install.
% Returns: retval - 1 for success, 0 for failure.
function retval = localInstallFiletoSystemDir(filelist, ISSYSTEM)
% Initialize return value
retval = 1;

% Set some flags for the installer.  Usually they are always
% set to 1, but there are some files that will not use 1
% all of these.
if ISSYSTEM
    sysfile = 1;
    register = 1;
    counter = 1;
else
    sysfile = 0;
    register = 1;
    counter = 0;
end
% Call the mex file once for each file on the list
for index = 1:length(filelist)
   filename = filelist{index};
   [status, errmsg] = mbcsetup('install', filename, sysfile, register, counter);
   if (status == 0) 
      disp(['Error updating ' filename]);
      retval = 0;
   end
   if ~isempty(errmsg)
      disp(errmsg);
   end
end



%%%%%%%%%%%%%%%%
% Install add-on's
%%%%%%%%%%%%%%%%
function i_addon
% scan for available and current add-on packages, and present GUI for altering them
mbcaddongui;
