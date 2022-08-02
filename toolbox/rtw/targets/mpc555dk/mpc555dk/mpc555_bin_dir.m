% File : mpc555_bin_dir
%
% Abstract :
%   
%   Returns a file path that represents the location of
%   target binary files given a certain Target Prefs 
%   configuration.
%
%   For example if 
%       TargetBoardProcessorVariant = '555'
%       ToolChain = 'Diab'
%
%   this function will return
%       'bin\DIAB\555'

%  Copyright 2002-2003 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $
%  $Date: 2004/04/19 01:26:50 $ 
function dir = mpc555_bin_dir
prefs = RTW.TargetPrefs.load('mpc555.prefs');


switch prefs.ToolChain
case 'Diab'
	dir = fullfile('bin','DIAB');
case 'CodeWarrior'
	dir = fullfile('bin','CODE_WARRIOR');
end

dir = fullfile(dir, prefs.TargetBoard.ProcessorVariant);
