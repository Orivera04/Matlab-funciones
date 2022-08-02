function [View,OK] = hide(node,cgh,View)
%HIDE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:26:56 $

if isfield(View.Handles, 'MessageID')
    cgh.removeStatusMsg(View.Handles.MessageID);
end
OK = 1;
