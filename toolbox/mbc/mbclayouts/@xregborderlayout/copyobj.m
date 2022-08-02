function newobj=copyobj(obj,fig)
%COPYOBJ  reate a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:34:44 $

newobj = obj;

% pass on call to parent
newobj.xregcontainer = copyobj(obj.xregcontainer,fig);

% create new copy of grid definition object
newobj.hGrid = obj.hGrid.copy;
connectdata(newobj, newobj.hGrid);
