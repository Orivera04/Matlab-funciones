function ret=canpaste(nd,data)
%CANPASTE Indicate whether node can paste data
%
%  OUT=CANPASTE(NODE,DATA)  return value is no-zero if the data on the
%  clipboard can be pasted into the currently selected region of the table
%  in this node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:34:18 $

pT = getdata(nd);
cgb = cgbrowser;
d = cgb.getViewData(guid(nd));
if pT.getNumAxes==1
    ret = d.Handles.Editor1D.canPaste;
else
    ret = d.Handles.Editor2D.canPaste;
end
