function newobj=copyobj(obj,fig)
% COPYOBJ  Create a copy of an object in a new figure
%
%   NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%   OBJ in the figure FIG.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 07:41:45 $

% Created 23/2/2000

% copy data structure
newobj=obj;

ud=get(newobj.xregtable,'userdata');

%copy table object
newobj.xregtable=copyobj(newobj.xregtable,fig);

% copy datastore
newobj.objecthandle=copyobj(newobj.objecthandle,fig);

% update callbacks
newobj.xregtable(ud.btnrows,4).callback=['toggleterm(get(' sprintf('%20.15f',newobj.objecthandle) ',''userdata''));'];
newobj.xregtable(ud.chboxrows,1).callback=['checkterms(get(' sprintf('%20.15f',newobj.objecthandle) ',''userdata''));'];
newobj.xregtable(ud.chboxrows,1).buttondownfcn=['checkterms(get(' sprintf('%20.15f',newobj.objecthandle) ',''userdata''));'];

% update datastore
builtin('set',newobj.objecthandle,'userdata',newobj);
% update badim userdata handle
ud.badim=get(get(newobj.xregtable,'bghandle'),'children');
set(newobj.xregtable,'userdata',ud);

return
