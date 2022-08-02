% parent function varargout = tgtaction(varargin)
% TGTACTION target specific implementation for target specific
% actions like 'run'

% Copyright 2002 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1 $ $Date: 2002/10/02 10:15:38 $
%   $Date: 2002/10/02 10:15:38 $

%
% Argument handling
%

% varargout = feval(action, varargin{1:end});

switch action
 case 'build'
  %function varargout = build(varargin)
  % building with diab happens from make_rtw.
  % BUILD a tgtaction stub to show that the build method has been
  % invoked. BUILD is performed by the makefile for diab and no
  % tgtaction is required.

  disp(['The build process for diab is performed by the standard RTW' ...
	' make process']);

 case 'run'
  % RUN a tgtaction method to run the compiled target.

  % Get the full path to the executable used to start
  % SingleStep. This is dependent on what connection is being used,
  % we currently use an OCDemon(tm) Macraigor Systems Wiggler(tm),
  % which uses SingleStep's bdmp58.exe.
  sdsExe = getsdsexe;

  % Get the SingleStep WSP (workspace) file for
  % loading and running from RAM
  sdsRAMwsp  = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', ...
			'mpc555dk', 'common', 'drivers', 'app_startup', ... 
			'mw_ram.wsp');

  % Get the SingleStep SCR (script) file name for
  % loading and running from RAM
  % Get build directory from rtwattic
  mpc555pil_make_rtw_hook('restoreRTWattic');
  modelName = mpc555pil_make_rtw_hook('getfromRTWattic','modelName');
  BuildDir = rtwprivate('rtwattic','getBuildDir');
  
  % If needs translate into DOS 8.3 format
  if (any(isspace(BuildDir)) ~= 0)
    % Get the trans2dos utility executable
    trans2dos = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', ...
    			'mpc555dk', 'common', 'tools', 'win32', 'trans2dos.exe');
    
    [status, BuildDir] = dos([trans2dos ' "' BuildDir '"']);
    BuildDir = strtok(BuildDir);
  end
  % the script is generated on the fly and called <model>.scr
  ModelScript    = [modelName '_ram.scr'];
  sdsRAMscr      = fullfile(BuildDir, ModelScript);

  % Build the path to this utility, which co-exists with the
  % ancillary files.
  ThisFile = which(mfilename);
  [fpath, name, ext, ver]= fileparts(ThisFile);

  % Build and execute the necessary command
  sdsArgs   = ['-P -S ' sdsRAMwsp ' -r  ' sdsRAMscr];
  sdsCmd = ['start ' sdsExe ' ' sdsArgs];
  disp(['Execute SingleStep as: ' sdsCmd]);
  [s,w] = system(sdsCmd);

 otherwise
end


