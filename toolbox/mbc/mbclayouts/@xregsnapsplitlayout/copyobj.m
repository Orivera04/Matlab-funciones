function newobj=copyobj(obj,fig)
%COPYOBJ Create a copy of an object in a new figure
%
%  NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object OBJ in the
%  figure FIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:36:54 $

newobj = obj;

% copy graphics objects
newobj.xregcontainer = copyobj(obj.xregcontainer,fig);
ud = get(newobj.xregcontainer,'userdata');
ud.rsbutton = copyobj(ud.rsbutton,fig);
connectdata(newobj, ud.rsbutton); 
set(newobj.xregcontainer,'userdata',ud);

fnhndl = get(ud.rsbutton,'ButtonDownFcn');
fnhndl = fnhndl{1};
% update copy of itself and the callback
set(ud.rsbutton,'ButtonDownFcn',{fnhndl,newobj,0},...
    'MoveToTopFcn',{fnhndl,newobj,1},...
    'MoveToBottomFcn',{fnhndl,newobj,2},...
    'MoveToLeftFcn',{fnhndl,newobj,3},...
    'MoveToRightFcn',{fnhndl,newobj,4});
