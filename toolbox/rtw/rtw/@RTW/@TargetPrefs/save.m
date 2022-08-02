function save(h)
%SAVE  Save the preferences value. 

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:16:42 $
    % Under new implementation, all TargetPrefs settings for different
    % targets will be saved into same group - 'TargetPrefs', and
    % preference name will be 'PackageName_ClassName'. For example, i960
    % prefs will be saved as setpref('TargetPrefs', 'i960_i960prefs', obj).
    groupName = 'TargetPrefs';
    % convert Package.Class into Package_Class
    prefName = strrep(h.class, '.', '_');
    
    try 
      setpref(groupName, prefName, h);
    catch
      error('Failure attempting to store target preferences');
    end
