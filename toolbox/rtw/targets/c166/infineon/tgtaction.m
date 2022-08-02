% parent function varargout = tgtaction(varargin)
% TGTACTION target specific implementation for target specific
% actions like 'run'

% Copyright 2002-2003 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.3.4.2 $
%   $Date: 2004/04/19 01:18:47 $

%
% Argument handling
%

% Get model name and buid directory from cache
modelName = c166_make_rtw_hook('getModelName');
buildDir = c166_make_rtw_hook('getBuildDir');

% If needs translate into DOS 8.3 format
if (any(isspace(buildDir)) ~= 0)
  % Get the trans2dos utility executable
  trans2dos = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', ...
                       'c166', 'common', 'tools', 'win32', 'trans2dos.exe');
  
  [status, buildDir] = dos([trans2dos ' "' buildDir '"']);
  buildDir = strtok(buildDir);
end

% Get the full path to the executable used to start Minimon.
prefs = RTW.TargetPrefs.load('c166.prefs');
minimonExe = prefs.BootstrapLoaderExe;
% Existence check
if exist(minimonExe)~=2
  error([...
      'The executable file ' minimonExe ' does not exist. '...
      'This error may occur if the MiniMon monitor for C16x is not '...
      'installed, or if the location is not set in the target '...
      'preferences. To correct this problem, you must install ' ...
      'the MiniMon freeware monitor software from Infineon and '...
      'set the appropriate fields in the C166 Target Preferences. '...
      'At the time of writing, MiniMon is available from the Infineon '...
      'web site at http://www.infineon.de/ --> Site Map --> Products '...
      '16-bit Microcontrollers --> minimon_c16x_223_setup_2.zip. Minimon '...
      'may need to be configured for your target processor; see the ' ...
      'Embedded Target for Infineon C166 documentation for an example.']);
end

% Get the script file used to launch Minimon
minimonScriptFile  = [buildDir filesep  'minimon_script.scm'];

% Build and execute the necessary command
minimonArgs   = [minimonScriptFile];
minimonCmd = ['start ' minimonExe ' ' minimonArgs];
disp(['Execute MiniMon as: ' minimonCmd]);
[s,w] = system(minimonCmd);


