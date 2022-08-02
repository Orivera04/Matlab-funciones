function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:32 $

newobj = obj;

newobj.xregcontainer=copyobj(obj.xregcontainer,fig);

newobj.panel = xregGui.panel('parent', fig, ...
    'visible', obj.panel.visible, ...
    'position', obj.panel.position, ...
    'type', obj.panel.type);
connectdata(newobj, newobj.panel);

newobj.rtP = xregGui.RunTimePointer(obj.rtP.info);
connectdata(newobj, newobj.rtP);
