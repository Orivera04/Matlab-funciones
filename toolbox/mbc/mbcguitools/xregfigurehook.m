function L= xregfigurehook(F)
%XREGFIGUREHOOK  Return a hook-on point for a custom control

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:23 $

F = handle(F);
if isempty(F.findprop('ControlHook'))
   p = schema.prop(F, 'ControlHook', 'handle');
   F.ControlHook = xregGui.uilatch(F);
end
L = F.ControlHook;