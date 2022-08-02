% File : get_current_toolchain
%
% Abstract :
%   Will return either
%
%           CodeWarrior
%     or    Diab
%

% Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.3.6.2 $
%   $Date: 2004/04/19 01:26:44 $
function toolchain = get_current_toolchain
    prefs = RTW.TargetPrefs.load('mpc555.prefs');
	 try
		 prefs.validate;
	 catch
		uiwait(errordlg(lasterr,'Target Preference Error'));
		prefs.gui;
		return
	 end
    toolchain = lower(prefs.ToolChain);
