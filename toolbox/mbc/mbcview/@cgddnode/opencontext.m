function opencontext(ddnode,h,x,y)
%CGDDNODE/OPENCONTEXT  Overloaded context menu interface method for cgbrowser
%
%  OPENCONTEXT(NODE,H_BROWSER,X,Y)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:23:42 $

d = h.getViewData;

menu = d.Handles.ContextMenu;
conpos = [x y];
set(menu, 'position', conpos, 'visible', 'on');
