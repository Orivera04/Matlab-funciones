function makeCmdOut = proosek_wrap_make_cmd_hook(args)
%
% The RTW build process uses MAKECMD in the TMF to determine the type of
% <model>.bat to create. Since Proosek invokes 'make', the standard RTW
% build process decides make.exe maps to the lcc tools and the generated
% .bat file defaults to lcc. Providing this target specific file allows
% the target to setup environment variables for Proosek before invoking
% make.
%

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.6.4.1 $  $Date: 2004/04/19 01:31:09 $

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
    prefs = osek.prefs;
    prefs = prefs.load('osek.prefs');
  catch
    error(lasterr);
  end
  
  proosek = prefs.ImpPath;
  fprintf(cmdFileFid, 'set MATLAB=%s\n',matlabroot);
  fprintf(cmdFileFid, 'set OSEK_BASE=%s\n',proosek);

  fprintf(cmdFileFid, 'set GCC_EXEC_PREFIX=%%OSEK_BASE%%\\gcc-powerpc-eabi\\lib\\gcc-lib\\\n');
  path = getenv('Path');
  fprintf(cmdFileFid, ...
      'set path=%%OSEK_BASE%%\\gcc-powerpc-eabi\\bin;%%OSEK_BASE%%\\bin;%s\n',...
      path);

  fullMakeCmd = fullfile(matlabroot,'rtw','bin','win32', makeCmd);
  fprintf(cmdFileFid, '%s\n', fullMakeCmd);
  fclose(cmdFileFid);
  makeCmdOut = cmdFile;
  
  if exist(prefs.ImpPath)~=7
    error(['Invalid path to ProOSEK: ' prefs.ImpPath]);
  end

%endfunction proosek_wrap_make_cmd_hook
