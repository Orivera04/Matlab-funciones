function [View,OK] = hide(node,cgh,View)
%HIDE Browser interface hide method
%
%  [VIEW, OK] = HIDE(NODE, CGB, VIEW) is executed before a node is hidden
%  in the cage browser.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.2.3 $  $Date: 2004/02/09 08:22:51 $

View = pMessage(View, '');

% close all the libraries
libs = pGetFeatureLibraries;
for n=1:size(libs,1)
    closefcn = libs{n,2}{2};
    feval(closefcn, node)
end

% close the stratergy model
mdl = View.sys;
if ~isempty(mdl) & ishandle(mdl)
    set_param(mdl,'CloseFcn', '');
    set_param(mdl,'Dirty', 'off');
    try
        close_system(mdl);
    end
end

OK = 1;
cgsurfaceviewer('hide');
return

