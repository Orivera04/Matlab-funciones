function newobj=copyobj(obj,fig)
%COPYOBJ  Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:37:02 $

newobj = obj;
newobj.xregcardlayout = copyobj(obj.xregcardlayout,fig);

fa = xregGui.figureaxes;
newobj.axes = getbgaxes(fa,fig);

% copy graphics objects
newobj.bgpatch = double(copyobj(handle(obj.bgpatch),newobj.axes));
newobj.blackline = double(copyobj(handle(obj.blackline),newobj.axes));
newobj.darkline = double(copyobj(handle(obj.darkline),newobj.axes));
newobj.whiteline = double(copyobj(handle(obj.whiteline),newobj.axes));
newobj.lightline = double(copyobj(handle(obj.lightline),newobj.axes));
connectdata(newobj, [newobj.whiteline, newobj.lightline, newobj.darkline, ...
    newobj.blackline newobj.bgpatch]);

ud=get(obj.whiteline,'userdata');
ud.tablabels=double(copyobj(handle(ud.tablabels),fig));
if ~isempty(ud.tablabels)
    connectdata(newobj, ud.tablabels);
end

cbfcn=get(ud.tablabels(1),'buttondownfcn');
cbfcn=cbfcn(1:2);
for n=1:length(ud.tablabels)
    set(ud.tablabels(n),'buttondownfcn',[cbfcn,{n}]);
end

set(newobj.whiteline,'userdata',ud);

% update copy of itself
builtin('set',newobj.blackline,'userdata',newobj);
