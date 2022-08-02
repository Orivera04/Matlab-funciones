function makeCmdOut = osekworks_wrap_make_cmd_hook(args)
%
% The RTW build process uses MAKECMD in the TMF to determine the type of
% <model>.bat to create. Since OSEKWorks invokes 'make', the standard RTW
% build process decides make.exe maps to the lcc tools and the generated
% .bat file defaults to lcc. Providing this target specific file allows
% the target to setup environment variables for OSEKWorks before invoking
% make.
%

% Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $  $Date: 2004/04/19 01:31:05 $

  makeCmd        = args.makeCmd;
  modelName      = args.modelName;
  verbose        = args.verbose;
  
  % args.compilerEnvVal not used

  cmdFile = ['.\',modelName, '.bat'];
  cmdFileFid = fopen(cmdFile,'wt');
  if ~verbose
    fprintf(cmdFileFid, '@echo off\n');
  end
  
  try
    prefs = RTW.TargetPrefs.load('osek.prefs');
  catch
    error(lasterr);
  end
  
  fprintf(cmdFileFid, '@set WIND_BASE=%s\n', prefs.ImpPath);
  fprintf(cmdFileFid, '@set WIND_HOST_TYPE=x86-win32\n');
  fprintf(cmdFileFid, '@set WIND_KERNEL=OSEKWorks\n');

  % If DIABLIB env. var not defined, setup to point at the Diab compiler under the
  % OW tree and add this diab\4.4b\win32\bin dir to the path
  diab = getenv('DIABLIB');
  if isempty(getenv('DIABLIB'))
    needDiabLib = true;
    diabRoot = fullfile(prefs.ImpPath,'host','diab','4.4b');
    fprintf(cmdFileFid, '@set DIABLIB=%s\n', diabRoot);
  else
    needDiabLib = false;
  end

  osekworks = fullfile(prefs.ImpPath,'target','osekworks');
  fprintf(cmdFileFid, '@set OSEKWORKS=%s\n', osekworks);
  path = getenv('Path');
  owpath1 = fullfile(prefs.ImpPath,'host','license;');
  if ~isempty(strfind(path,owpath1)) owpath1 = ''; end
  owpath2 = fullfile(prefs.ImpPath,'host','diab','4.4b','WIN32','bin;');
  if ~needDiabLib || ~isempty(strfind(path,owpath2)) owpath2 = ''; end
  fprintf(cmdFileFid, '@set Path=%s%s%s\n', owpath1, owpath2, path);
  fullMakeCmd = fullfile(prefs.ImpPath,'host','x86-win32',...
                         'bin', makeCmd);
  fprintf(cmdFileFid, '%s\n', fullMakeCmd);
  fclose(cmdFileFid);
  makeCmdOut = cmdFile;

  if exist(prefs.ImpPath)~=7
    error(['Invalid path to OSEKWorks: ' prefs.ImpPath]);
  end

%endfunction osekworks_wrap_make_cmd_hook
