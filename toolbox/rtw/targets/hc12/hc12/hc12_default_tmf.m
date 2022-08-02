function [tmf] = hc12_default_tmf
%HC12_DEFAULT_TMF Returns the "default" template makefile for use with hc12.tlc
%
%       See get_tmf_for_target in the toolbox/rtw/private directory for more 
%       information.

%       Copyright 2002-2003 The MathWorks, Inc.
%       $Revision: 1.1.6.2 $
%       $Date: 2004/04/19 01:23:38 $

HC12_PREFS = RTW.TargetPrefs.load('hc12.prefs','structure');

switch lower(HC12_PREFS.TargetCompiler)
 case 'codewarrior'
  tmf = 'hc12_codewarrior.tmf';
 otherwise
  msg = ['Unsupported target compiler: ',HC12_PREFS.TargetCompiler ...
	 '. Run RTW.TargetPrefs.load(''hc12.prefs'',''structure'') to check TargetCompiler preference setting']
  error(msg);
end

%EOF hc12_default_tmf.m