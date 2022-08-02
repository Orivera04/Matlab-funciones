function switches = getdebugswitches(obj)

% Copyright 2002 The MathWorks, Inc.
% $Revision: 1.1 $ $Date: 2002/10/23 01:49:37 $

  try
    lasterr('');
    prefsObj = osek.prefs.load('osek.prefs');
    switches = prefsObj.ToolChain.DebuggerSwitches;
  end
  
  error(lasterr);

return;

