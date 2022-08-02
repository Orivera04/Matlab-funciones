function ThisPath = getsdsexe(obj)
% GETSDSEXE utility function to return a string containing the 
% filename of the program that is used to start SingleStep

% Copyright 2002 The MathWorks, Inc.
% $Revision: 1.4 $ $Date: 2002/11/29 15:26:30 $


prefs = RTW.TargetPrefs.load('mpc555.prefs');
ThisPath = prefs.ToolChainOptions.DebuggerPath;
DebuggerExe = prefs.ToolChainOptions.DebuggerExecutable;
% A user may not be using the SingleStep debugger. We will
% only throw an error if the entry is set and it is incorrect.
% If it is empty we will let it pass.
if isempty(ThisPath)
    error('Please set the Path to SingleStep debugger.');
end

path = fullfile(prefs.ToolChainOptions.DebuggerPath,'cmd', prefs.ToolChainOptions.DebuggerExecutable);
ThisPath = fullfile(ThisPath, 'cmd' , DebuggerExe );



