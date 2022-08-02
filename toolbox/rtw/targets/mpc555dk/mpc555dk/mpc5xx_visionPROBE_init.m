% File : mpc5xx_visionPROBE_init
%
% Abstract :
%   Initialise the visionPROBE for use with the MPC5xx.
%   This needs to be done each time you change target board.
%

%  Copyright 2003-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $
%  $Date: 2004/04/19 01:27:13 $ 
   
prefs = RTW.TargetPrefs.load('mpc555.prefs');
try
	prefs.validate;
catch
	uiwait(errordlg(lasterr,'Target Preference Error'));
	prefs.gui;
	return;
end

% call tgt action
% 
% NOTE: visppcinit tgt action does not exist for CodeWarrior
% NOTE: visppcinit tgt action checks for VisionPROBE settings in tgt prefs
try 
    tgtaction('visppcinit');
catch
    nline = sprintf('\n');
    disp(['Failure initialising the visionPROBE!' nline nline ...
          'To initialise the visionPROBE you must have selected the ' nline ...
          'Diab toolchain in the Target Preferences.' nline ...
          'The Target Preferences must also be configured for the visionPROBE.' nline]); 
    rethrow(lasterror);
end

