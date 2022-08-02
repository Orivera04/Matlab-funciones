function tmf = mpc555exp_default_tmf()
%MPC555EXP_DEFAULT_TMF Returns the correct template makefile for use with mpc555exp.tlc

%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $
%   $Date: 2004/04/19 01:27:00 $

prefs = RTW.TargetPrefs.load('mpc555.prefs');

switch lower(prefs.ToolChain)
	case 'diab'
		tmf = 'mpc555exp.tmf';
	case 'codewarrior'
		tmf = 'mpc555exp.tmf';
	otherwise
		msg = ['Unsupported target compiler: ', prefs.ToolChain ];
		error(msg);
end

%end mpc555pil_default_tmf.m
