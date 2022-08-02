% parent function varargout = tgtaction(varargin)
% TGTACTION target specific implementation for target specific
% actions like 'run'

% Copyright 2002-2003 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.8.4.2 $
%   $Date: 2004/04/19 01:18:59 $

%
% Argument handling
%

% varargout = feval(action, varargin{1:end});


switch action
 case {'Download_and_run_with_debugger','Run_with_simulator'}

  % Get the full path to the executable used to start
  % CrossView.
  prefs = RTW.TargetPrefs.load('c166.prefs');
  xvwExe = prefs.TargetDebuggerExe;

  % Get the command file used to launch CrossView
  xvwLaunchFile  = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', ...
			    'c166','common','tools','tasking',...
			    'crossview_startup_options.txt');

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

  %
  % If a custom CrossView startup options file has been specified, check that it exists
  %
  XviewStartupOptionsFile=varargin{2};
  if isempty(XviewStartupOptionsFile) | strcmp(XviewStartupOptionsFile,' ')
    XviewStartupOptionsFile=[buildDir filesep 'crossview_startup_options.txt'];
  else
    if exist(XviewStartupOptionsFile)~=2
      error(['The specified Cross View Startup Options file ''' XviewStartupOptionsFile ...
	     ''' does not exist']);
    end
  end
  
  % Build and execute the necessary command
  xvwArgs   = [' -f ' XviewStartupOptionsFile ];
  xvwCmd = ['start ' xvwExe ' ' xvwArgs];
  disp(['Execute CrossView as: ' xvwCmd]);
  [s,w] = system(xvwCmd);
  
 otherwise
end


