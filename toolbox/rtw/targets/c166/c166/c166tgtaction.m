function varargout = c166tgtaction(varargin)
% C166TGTACTION gateway to target specific actions like 'run'

% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.6.4.2 $ $Date: 2004/04/19 01:18:39 $

%
% tgtaction('Download_and_run')
% tgtaction('Download_and_run_with_debugger')
% tgtaction('Run_with_simulator')
%
% - Requires a TargetCompiler related directory.

%
% Argument handling
%
errmsg = [];

switch nargin
case 0
 errmsg = [' requires at least a single action argument'];
 otherwise
  action = varargin{1};
end
if isempty(action)
  action='empty';
end

%
% Develop the path to this file, its parent directory 
% and the tools directory
%
ThisFile = which(mfilename);
[fpath, name, ext, ver]= fileparts(ThisFile);
[ParentDir, name, ext, ver] = fileparts(fpath);
toolsRoot = fullfile(ParentDir, '');

%
% get the required download method
%
if strcmp(action,'Download_and_run')
  downloadSubDir = 'infineon';
else
  % Compiler specific support
  downloadSubDir = 'tasking';
end

%
% Create the file path that will be executed
%
downloadActionMFile = fullfile(toolsRoot, downloadSubDir,  'tgtaction.m');

if isempty(errmsg)
    try 
        run(downloadActionMFile);
    catch
        % Should check for errors to pass back
        errmsg = lasterr;
    end
end
if ~isempty(errmsg)
    error(errmsg);
end
