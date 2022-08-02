function ret=canpaste(nd,data)
% CANPASTE  Indicate whether node can paste data
%
%  OUT=CANPASTE(NODE,DATA)
%  The return value is non-zero if the data on the
%  clipboard can be pasted into the currently
%  selected region of the table in one of the nodes
%  currently on view.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:25:24 $

cgb=cgbrowser;
d=cgb.getViewData(guid(nd));
tp = d.Handles.TablePane;

pane = tp(1);
ret = pane.canPaste;
if ~ret & length(tp)>1
    pane = tp(2);
    ret=pane.canPaste;
end

