function newobj=copyobj(obj,fig)
% COPYOBJ  Create a copy of an object in a new figure
%
%   NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%   OBJ in the figure FIG.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:17:57 $

newobj=obj;

% create new pointer reference
newobj.g=xregGui.RunTimePointer;
newobj.g.LinkToObject(fig);

ud=obj.g.info;
ud.axes=copyobj(ud.axes,fig);
newobj.g.info=ud;
return