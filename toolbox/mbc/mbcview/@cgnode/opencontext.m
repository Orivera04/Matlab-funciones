function opencontext(node,h,x,y)
%OPENCONTEXT  Context menu interface for cgbrowser
%
%  OPENCONTEXT(NODE,H_BROWSER,X,Y)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:25:12 $

% Bring up the default browser context menu
set(h.DefaultContextMenu,'position',[x y],'visible','on')