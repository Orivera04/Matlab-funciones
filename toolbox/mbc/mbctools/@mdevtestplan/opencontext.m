function opencontext(nd,h,x,y)
%OPENCONTEXT   Open context menu for testplan
%
%  OPENCONTEXT(NODE,H_BROWSER,X,Y)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:08 $


vdata=h.GetViewData;
% Bring up the default browser context menu
set(vdata.menus.ContextMenu,'position',[x y],'visible','on')