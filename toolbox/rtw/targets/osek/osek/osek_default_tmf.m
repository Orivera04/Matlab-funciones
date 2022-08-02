function [tmf,envVal] = osek_default_tmf
%OSEK_DEFAULT_TMF Returns the implementation specific template makefile based
%                 on target preferences setting.
%
%       Copyright 2002-2003 The MathWorks, Inc.
%       $Revision: 1.7.6.2 $
  
  % Get the osek preferences
  try
    prefs = RTW.TargetPrefs.load('osek.prefs','structure');
  catch
    error(lasterr);
  end

  % Get the desired OSEK implementation and ensure it is supported
  if ~isfield(prefs, 'Implementation')
    error('OSEK preferences not set correctly, please update Target Preferences.');
  end
  imp = deblank(lower(prefs.Implementation));
  stfname = strtok(lower(get_param(bdroot, 'RTWSystemTargetFile')));
  
  if ~strncmp(imp, stfname, length(stfname) - length('.tlc'))
    msg = ['System Target file name: ', stfname,...
           ' does not match Implementation specified in Target Preferences: ', imp];
    error(msg);
  end

  if ~exist([imp, '_make_rtw_hook'])
    msg = ['Files for OSEK Implementation: ''', imp, ''' cannot be found.'];
    error(msg);
  end
  
  % Return the desired template make file.
  tmf = [imp, '.tmf'];
  
  % This argument is unused
  envVal = ''; 
  
%end osek_default_tmf.m
