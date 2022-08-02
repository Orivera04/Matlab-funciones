function hc12editprefs
%HC12EDITPREFS Launch target preferences editor 
%   HC12DITPREFS gets the target preferences object for HC12 and launches the
%   target preferences editor. When a target preference object has already been
%   activated, that object will be used. Otherwise, a new factory default
%   preference object is created.
%

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:23:39 $
  
% Instantiate a targetprefs object
  tp = RTW.TargetPrefs.load('hc12.prefs');
  
  % Invoke the GUI
  gui(tp);
