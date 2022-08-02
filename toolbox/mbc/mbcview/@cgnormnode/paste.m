function paste(nd,data)
% PASTE  Paste data into a table
%
%  PASTE(NODE,DATA) Pastes the given data into the currently
%  selected region of the table of the currently selected node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:25:42 $

cgb=cgbrowser;
d=cgb.getViewData(guid(nd));
tp = d.Handles.TablePane;

pane = tp(1);
if ~pane.canPaste & length(tp)>1
    % two tables visible.  try the other one
    pane = tp(2);
end
pane.paste;

