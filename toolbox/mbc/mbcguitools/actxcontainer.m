function ax_obj = actxcontainer(ax_obj)
% ACTXCONTAINER  ActiveX wrapping class
%
%  A=ACTXCONTAINER(C) wraps the control C in a class
%  which provides overloaded set and get position calls.
%  This allows you to use ActiveX objects in layout managers.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:09 $


% add run-time properties to the object
p = schema.prop(ax_obj,'Position','rect');
p = schema.prop(ax_obj,'Visible','on/off');
p = schema.prop(ax_obj,'Enable','string');

% initialise properties  (we assume the control has a visible property)
ax_obj.Position = move(ax_obj)+[1 1 0 0];
vis = abs(ax_obj.ControlVisible);
if vis
   ax_obj.Visible = 'on';
else
   ax_obj.Visible = 'off';
end
en = abs(ax_obj.Enabled);
if en
   ax_obj.Enable = 'on';
else
   ax_obj.Enable = 'off';
end

% 'Hidden' properties
p = schema.prop(ax_obj,'xListeners','handle vector');

ax_obj.xListeners = [handle.listener(ax_obj,ax_obj.findprop('Position'),'PropertyPostSet',@i_setPosition);...
      handle.listener(ax_obj,ax_obj.findprop('Visible'),'PropertyPostSet',@i_setVisible);...
      handle.listener(ax_obj,ax_obj.findprop('Enable'),'PropertyPostSet',@i_setEnable)];
% Hide the listeners property      
p.AccessFlags.PublicGet = 'off';
p.AccessFlags.PublicSet = 'off';
   

function i_setPosition(src,evt)
obj = evt.AffectedObject;
if strcmp(obj.Visible,'on')
   move(obj,obj.position-[1 1 0 0]);
end

function i_setEnable(src,evt)
obj = evt.AffectedObject;
if strcmp(evt.NewValue,'on')
   obj.Enabled = 1;
else
   obj.Enabled = 0;
end

function i_setVisible(src,evt)
obj = evt.AffectedObject;
if strcmp(evt.NewValue,'on')
   obj.ControlVisible = 1;
   move(obj,obj.Position - [1 1 0 0]);
else
   obj.ControlVisible = 0;
   move(obj,[-2 -2 1 1]);
end