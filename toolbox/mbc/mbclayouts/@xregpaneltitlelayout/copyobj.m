function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:36:37 $

newobj = obj;
newobj.xregcontainer = copyobj(obj.xregcontainer,fig);

newobj.outerpanel = xregGui.panel('parent',fig,...
    'visible', obj.outerpanel.visible, ...
    'position', obj.outerpanel.position);
newobj.ttlpanel = xregGui.filledPanel('parent',fig,...
    'visible', obj.ttlpanel.visible, ...
    'position', obj.ttlpanel.position, ...
    'type', 'out', ...
    'backgroundcolor', obj.ttlpanel.backgroundcolor);
newobj.title = copyobj(obj.title, fig);
connectdata(newobj, newobj.outerpanel);
connectdata(newobj, newobj.ttlpanel);
connectdata(c, newobj.title);

newobj.ptr = xregGui.RunTimePointer(obj.ptr.info);
connectdata(newobj, newobj.ptr);

ud = obj.ptr.info;
if ~isempty(ud.dividerhandle)
    newdiv =  xregGui.oblong('parent', fig, ...
        'hittest', 'off', ...
        'layer','middle', ...
        'visible', ud.dividerhandle.visible, ...
        'position', ud.dividerhandle.position, ...
        'color', ud.dividerhandle.color);
    connectdata(newobj, newdiv);
    newud = newobj.ptr.info;
    newud.dividerline = newdiv;
    newobj.ptr.info = newud;
end
