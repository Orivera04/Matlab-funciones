function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:05 $

newobj = obj;
newobj.xreggridlayout = copyobj(obj.xreggridlayout,fig);

newobj.g = xregGui.RunTimePointer;
connectdata(newobj, newobj.g);
newobj.g.info = obj.g.info;
