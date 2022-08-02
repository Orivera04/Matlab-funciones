%MWSAMP Sample script to create ActiveX object.
%  Script to create the Matlab sample ActiveX control. The script
%  sets the 'Label' and 'Radius' properties and invokes the 'Redraw'
%  method.
%
%  SAMPEV is the event handler for this control. The only event
%  fired by the control is 'Click', which is fired when the user
%  clicks on the control with the mouse. The event handler displays
%  a text message in the Matlab command window when the event is fired.
%
%  See also: SAMPEV and ACTXCONTROL.

% Copyright 1984-2000 The MathWorks, Inc. 
% $Revision: 1.6 $ $Date: 2000/06/01 23:27:06 $

% Create a figure
f = figure('Position', [100 200 200 200]);

% create the control to fill the figure
h = actxcontrol('MWSAMP.MwsampCtrl.1', [0 0 200 200], f, ...
         {'Click','sampev';'DblClick','sampev';'MouseDown','sampev'})

% Set the label of the control
set(h, 'Label', 'Click to fire an event');

% Dot-name notation may be used in place of the SET command.
% set(h,'Radius',40);
h.Radius=50;

% Tell the control to redraw itself by invoking the Redraw method.
invoke(h, 'Redraw');

% Additional Sample code to invoke the Beep method, and release
% the interface.
% invoke(h, 'Beep');
% release(h)
