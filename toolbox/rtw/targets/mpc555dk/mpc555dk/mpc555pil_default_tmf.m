function tmf = mpc555pil_default_tmf()
%MPC555PIL_DEFAULT_TMF Returns the correct template makefile for use with mpc555pil.tlc

%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $
%   $Date: 2004/04/19 01:27:02 $


prefs = RTW.TargetPrefs.load('mpc555.prefs')

switch lower(prefs.ToolChain)
 case 'diab'
  tmf = 'mpc555pil_diab.tmf';
  if (strncmp('6.1',version,3) ~= 1)
    tmf = 'mpc555pil.tmf';
  end
 case 'codewarrior'
  tmf = 'mpc555pil_diab.tmf';
  if (strncmp('6.1',version,3) ~= 1)
    tmf = 'mpc555pil.tmf';
  end
 otherwise
  msg = ['Unsupported target compiler: ', prefs.ToolChain ...
	 '. Edit MPC555 Target Preferences to check the ToolChain preference setting']
  error(msg);
end

%end mpc555pil_default_tmf.m
