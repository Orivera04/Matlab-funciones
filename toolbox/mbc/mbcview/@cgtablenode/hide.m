function [d,OK] = hide(node,cgb,d)
%HIDE Hide the browser view
%
%  [DATA, OK] = HIDE(NODE, CGB, DATA) is executed before a browser view is
%  hidden.  If the OK flag is returned as false, the view will not be
%  hidden.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:34:21 $

if ~isempty(d.ShownMessageID)
    cgb.removeStatusMsg(d.ShownMessageID);
    d.ShownMessageID = [];
end

OK = 1;
