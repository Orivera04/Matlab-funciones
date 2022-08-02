function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:04 $

newobj = obj;
newobj.xregcontainer = copyobj(obj.xregcontainer,fig);

% copy graphics objects
newobj.datastore = xregGui.RunTimePointer(obj.datastore.info);
connectdata(newobj, newobj.datastore);

% Copy the dragger and correct the callback
newobj.rsbutton = double(copyobj(handle(obj.rsbutton),fig));
connectdata(newobj, newobj.rsbutton);

fnhndl = get(newobj.rsbutton,'ButtonDownFcn');
fnhndl{2} = newobj;
set(newobj.rsbutton,'buttondownfcn',fnhndl);
