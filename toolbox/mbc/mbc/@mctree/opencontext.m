function opencontext(nd,h,x,y)
%OPENCONTEXT  Default opencontext for MBrowser
%
%  OPENCONTEXT(NODE,H_BROWSER,X,Y)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:01 $


% Bring up the default browser context menu
set(h.DefaultTreeContext,'position',[x y],'visible','on')