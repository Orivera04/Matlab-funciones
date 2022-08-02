function c166editprefs
%C166EDITPREFS Launch target preferences editor 
%   C166EDITPREFS gets the target preferences object for C166 and launches the
%   target preferences editor. When a target preference object has already been
%   activated, that object will be used. Otherwise, a new factory default
%   preference object is created.
%

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.3 $
%   $Date: 2002/09/05 11:39:10 $
  
% Instantiate a targetprefs object
  tp = RTW.TargetPrefs.load('c166.prefs');
  
  % Invoke the GUI
  gui(tp);
