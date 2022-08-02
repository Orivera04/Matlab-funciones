function newobj=copyobj(obj,fig)
%COPYOBJ  Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:21 $

% copy data structure
newobj=obj;

set(fig,'renderer','zbuffer');
% copy graphics objects
newobj.patch=copyobj(obj.patch,fig);
newobj.axes=copyobj(obj.axes,fig);
newobj.colorbar.axes=copyobj(obj.colorbar.axes,fig);
newobj.xtext=copyobj(obj.xtext,fig);
newobj.xfactor=copyobj(obj.xfactor,fig);
newobj.ytext=copyobj(obj.ytext,fig);
newobj.yfactor=copyobj(obj.yfactor,fig);
newobj.ztext=copyobj(obj.ztext,fig);
newobj.zfactor=copyobj(obj.zfactor,fig);
newobj.badim=copyobj(obj.badim,fig);

% find new axes child objects
ch = get(newobj.axes,'children');
newobj.surf = handle(findobj(ch, 'type', 'patch'));
datatags = findobj(ch, 'type', 'text');
newobj.colorbar.bar=handle(get(double(newobj.colorbar.axes),'children'));

newobj.DataPointer = xregGui.RunTimePointer(obj.DataPointer.info);
newobj.DataPointer.LinkToObject(newobj.axes);
newobj.DataPointer.info.datataghandles = datatags;

% save an object handle in the patch for later use.
cb=get(newobj.xfactor,'callback');
set([newobj.xfactor;newobj.yfactor;newobj.zfactor],'callback',[cb(1) {newobj}]);
cb=get(newobj.colorbar.bar,'buttondownfcn');
set(newobj.colorbar.bar,'buttondownfcn',[cb(1) {newobj}]);

% turn on rotation on new axes
mv_rotate3d(newobj.axes,'ON');
return
