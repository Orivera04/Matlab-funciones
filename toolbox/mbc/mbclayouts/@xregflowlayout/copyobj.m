function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:03 $

newobj = obj;

% pass on call to parent
newobj.xregcontainer = copyobj(obj.xregcontainer,fig);

% create new pointer reference
newobj.g = xregGui.RunTimePointer;
connectdata(newobj, newobj.g);

% update data
newobj.g.info = obj.g.info;
