function newobj=copyobj(obj,fig)
% COPYOBJ  Create a copy of an object in a new figure
%
%   NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%   OBJ in the figure FIG.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:04 $

% Created 18/9/2000

newobj=obj;

% copy graphics objects
h=copyobj([obj.frame1;obj.text1;obj.frame2;obj.text2],fig);
newobj.frame1= h(1);
newobj.text1= h(2);
newobj.frame2= h(3);
newobj.text2= h(4);

% set callbacks
cbstr='%s(get(%20.15f,''userdata'')';
set(newobj.text1,'buttondownfcn',['rollcb(get(' sprintf('%20.15f',newobj.text1) ',''userdata''))']);
set(newobj.text2,'buttondownfcn',['rollcb(get(' sprintf('%20.15f',newobj.text1) ',''userdata''))']);

% save copy of object
builtin('set',newobj.text1,'userdata',newobj);
return