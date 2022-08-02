% Function: hc12_cwautomation_close
% Abstract: Creates the COM connection to CodeWarrior, clears all
% open projects and sets the cw version and root in the Target Preferences.
%
%% $Revision: 1.1.6.2 $  $Date: 2004/03/30 13:13:13 $
%% Copyright 2002-2004 The MathWorks, Inc.
function ICodeWarriorApp = hc12_cwautomation_close
  try
    ICodeWarriorApp = actxserver('CodeWarrior.CodeWarriorApp');
    while (1 == 1)
      e = invoke(ICodeWarriorApp.DefaultProject, 'Close');
    end
  catch
    lasterr('');
  end

  % Determine the CW version and root, then save in TgtPrefs
  % Assume 2.0 (1.2 is compatible w.r.t this target)  
  cwversion = '2.0';
  cwroot = '';
  try
    cwroot = regexprep(ICodeWarriorApp.FullName,'bin.*','');
    cwhelpfile = fullfile(cwroot,'bin','Plugins','Support','Products','CW_HC12.xml');
    if exist(cwhelpfile,'file') == 2
      domnode = xmlread(cwhelpfile);
      versionstr = domnode.getNodeValueString(6);
      if ~isempty(findstr(versionstr,'Motorola HC12 3.0'))
        cwversion = '3.0';
      end
    end
  catch
    lasterr('');
  end
  h = RTW.TargetPrefs.load('hc12.prefs');
  setCWInfo(h,cwversion,cwroot);
  return;
  