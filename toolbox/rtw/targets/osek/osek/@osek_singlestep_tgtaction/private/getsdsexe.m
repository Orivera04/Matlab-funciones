function ThisPath = getsdsexe(obj)
% GETSDSEXE utility function to return a string containing the 
% filename of the program that is used to start SingleStep

% Copyright 2002 The MathWorks, Inc.
% $Revision: 1.2 $ $Date: 2002/10/24 20:28:45 $

  try
    lasterr('');
    prefsObj = osek.prefs.load('osek.prefs');
    DebuggerEXE = prefsObj.ToolChain.DebuggerEXE;
    DebuggerPath = prefsObj.ToolChain.DebuggerPath;
    targetDebuggerEXE = fullfile(DebuggerPath, 'cmd', DebuggerEXE);
  end
  
  error(lasterr);

  % ThisPath='x:\share\apps\WindRiver\SingleStepDebugger\sds762';
  ThisPath = targetDebuggerEXE;

  % set up a default path when the given one does not produce 
  % a file spec that exists.
  if (exist(ThisPath) == 0)
    error(['The SingleStep debugger, ' ThisPath ', is not available']);
  end
  return;
