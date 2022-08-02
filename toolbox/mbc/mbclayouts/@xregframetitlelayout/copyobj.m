function newobj=copyobj(obj,fig)
%COPYOB  Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:56 $

newobj=obj;
newobj.xregcontainer = copyobj(obj.xregcontainer,fig);

fa=xregGui.figureaxes;
newax=getaxes(fa,fig);

% copy graphics objects
newobj.grayline = double(copyobj(handle(obj.grayline),newax));
newobj.whiteline = double(copyobj(handle(obj.whiteline),newax));
newobj.title = double(copyobj(handle(obj.title),fig));
connectdata(newobj, [newobj.whiteline, newobj.grayline, newobj.title]);

% update copy of itself
builtin('set',newobj.grayline,'userdata',newobj);
