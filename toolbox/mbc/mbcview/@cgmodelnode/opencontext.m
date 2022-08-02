function opencontext(ddnode,h,x,y)
%OPENCONTEXT  Overloaded context menu interface method for cgbrowser
%
%  OPENCONTEXT(NODE,H_BROWSER,X,Y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $  $Date: 2004/04/04 03:33:29 $

d = h.getViewData;

menu = d.NodeContextMenu;
conpos = [x y];
set(menu, 'position', conpos, 'visible', 'on');
