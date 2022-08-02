function newobj = copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:15 $

newobj = obj;
% create new pointer reference
newobj.g = xregGui.containerData;
newobj.g.TrackRepack = false;
newobj.g.position = obj.g.position;
if obj.g.frame
    newobj.g.frame = fig;
end
newobj.g.border = obj.g.border;
newobj.g.tag = obj.g.tag;
newobj.g.userdata = obj.g.userdata;
newobj.g.parent = fig;
newobj.g.PSobj = obj.g.PSobj;

el = obj.g.elements;
for n = 1:length(el(:))
    el{n} = copyobj(el{n},fig);
end
newobj.g.elements = el;

newobj.g.NeedRepack = false;
newobj.g.TrackRepack = obj.g.TrackRepack;
