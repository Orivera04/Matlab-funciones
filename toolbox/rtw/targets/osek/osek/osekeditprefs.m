function osekeditprefs
%OSEKEDITPREFS Launch target preferences editor 
%   OSEKEDITPREFS gets the target preferences object for OSEK and launches the
%   target preferences editor. When a target preference object has already been
%   activated, that object will be used. Otherwise, a new factory default
%   preference object is created.
%

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $
%   $Date: 2002/10/16 03:24:06 $
  
% Instantiate a targetprefs object
  tp = RTW.TargetPrefs.load('osek.prefs');
  
  % Invoke the GUI
  gui(tp);
