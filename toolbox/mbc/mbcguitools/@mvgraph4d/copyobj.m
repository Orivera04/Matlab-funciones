function newobj=copyobj(obj,fig)
%COPYOBJ  Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%  OBJ in the figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:41 $

% Created 23/2/2000

% copy data structure
newobj=obj;

set(fig,'renderer','zbuffer');
% copy graphics objects
newobj.patch=copyobj(obj.patch,fig);
newobj.badim=copyobj(obj.badim,fig);
newobj.axes=copyobj(obj.axes,fig);
newobj.colorbar.axes=copyobj(obj.colorbar.axes,fig);
newobj.colorbar.frame1=copyobj(obj.colorbar.frame1,fig);
newobj.colorbar.frame2=copyobj(obj.colorbar.frame2,fig);
newobj.colorbar.userange=copyobj(obj.colorbar.userange,fig);
newobj.xtext=copyobj(obj.xtext,fig);
newobj.xfactor=copyobj(obj.xfactor,fig);
newobj.ytext=copyobj(obj.ytext,fig);
newobj.yfactor=copyobj(obj.yfactor,fig);
newobj.ztext=copyobj(obj.ztext,fig);
newobj.zfactor=copyobj(obj.zfactor,fig);
newobj.ctext=copyobj(obj.ctext,fig);
newobj.cfactor=copyobj(obj.cfactor,fig);

% find new surf and patch objects
ch = get(newobj.axes,'children');
newobj.surf = handle(findobj(ch,'flat','type','patch'));
datatags = findobj(ch, 'flat', 'type', 'text');
ch=get(newobj.colorbar.axes,'children');
newobj.colorbar.bar=handle(findobj(ch,'flat','tag','cbar'));
newobj.colorbar.minrange=handle(findobj(ch,'flat','tag','minbar'));
newobj.colorbar.midrange=handle(findobj(ch,'flat','tag','midbar'));
newobj.colorbar.maxrange=handle(findobj(ch,'flat','tag','maxbar'));

newobj.DataPointer = xregGui.RunTimePointer(obj.DataPointer.info);
newobj.DataPointer.LinkToObject(newobj.axes);
newobj.DataPointer.info.datataghandles = datatags;

cb=get(newobj.xfactor,'callback');
set([newobj.xfactor;newobj.yfactor;newobj.zfactor;newobj.cfactor],...
   'callback',[cb(1), {newobj}]);
cb=get(newobj.colorbar.bar,'buttondownfcn');
set(newobj.colorbar.bar,'buttondownfcn',[cb(1),{newobj}]);
cb=get(newobj.colorbar.userange,'callback');
set(newobj.colorbar.userange,'callback',[cb(1),{newobj}]);
cb=get(newobj.colorbar.minrange,'buttondownfcn');
set([newobj.colorbar.minrange;newobj.colorbar.midrange;newobj.colorbar.maxrange],{'buttondownfcn'},...
   {[cb(1), {newobj,'min'}]; [cb(1), {newobj,'mid'}];[cb(1), {newobj,'max'}]});


% turn on rotation on new axes
mv_rotate3d(double(newobj.axes),'ON');
return