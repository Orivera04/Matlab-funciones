function data=copy(nd)
%COPY
% data=copy(node)
% Copies the data from the currently selected region
% of the table in the currently selected node onto the
% clipboard, and returns it.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:25:28 $
data = [];
cgb=cgbrowser;
d=cgb.getViewData(guid(nd));
tp = d.Handles.TablePane;

% Identify the current table (since there may be two on display)
pane = tp(1);
if ~pane.canCopy & length(tp)>1
    % two tables in current view.  must be the other one
    pane = tp(2);
end
pane.copy;
% call 'paste' to get a copy of the data to return
data=clipboard('paste');

