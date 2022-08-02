function newobj=copyobj(obj,fig)
% COPYOBJ  Create a copy of an object in a new figure
%
%   NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%   OBJ in the figure FIG.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:47 $

% Created 22/2/2000

% copy data structure
newobj=obj;

% copy graphics objects
newobj.patch=copyobj(obj.patch,fig);
newobj.badim=copyobj(obj.badim,fig);
newobj.axes=copyobj(obj.axes,fig);
newobj.hist.axes=copyobj(obj.hist.axes,fig);
newobj.factortext=copyobj(obj.factortext,fig);
newobj.factorsel=copyobj(obj.factorsel,fig);
newobj.parent=fig;

% find new patch and line objects and bad image
newobj.line=handle(get(newobj.axes,'children'));
newobj.hist.patch=handle(get(newobj.hist.axes,'children'));

% save an object handle in the patch for later use.
cb=get(obj.factorsel,'callback');
set(newobj.factorsel,'callback',[cb(1), {newobj}]);

return
