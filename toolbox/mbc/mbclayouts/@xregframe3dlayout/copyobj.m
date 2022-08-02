function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:34 $

newobj = obj;

newobj.xregcontainer = copyobj(obj.xregcontainer,fig);

fa=xregGui.figureaxes;
newobj.axes=getbgaxes(fa,fig);
% copy graphics objects
newobj.background= double(copyobj(handle(obj.background),newobj.axes));
newobj.cbobject= double(copyobj(handle(obj.cbobject),newobj.axes));
newobj.blackline= double(copyobj(handle(obj.blackline),newobj.axes));
newobj.darkline= double(copyobj(handle(obj.darkline),newobj.axes)); 
newobj.midline= double(copyobj(handle(obj.midline),newobj.axes)); 
newobj.lightline= double(copyobj(handle(obj.lightline),newobj.axes));
newobj.tagback= double(copyobj(handle(obj.tagback),newobj.axes));
newobj.tagtext= double(copyobj(handle(obj.tagtext),newobj.axes));

connectdata(newobj, [newobj.background, newobj.cbobject, ...
    newobj.darkline, newobj.blackline, ...
    newobj.midline, newobj.lightline, ...
    newobj.tagback, newobj.tagtext]);

% update buttondownfcn
if ~isempty(get(newobj.cbobject,'buttondownfcn'))
   set(newobj.cbobject,'buttondownfcn',['firebtndn(get(' sprintf('%20.15f',obj.background) ',''userdata''));']);
end

% update copy of itself
builtin('set',newobj.background,'userdata',newobj);
