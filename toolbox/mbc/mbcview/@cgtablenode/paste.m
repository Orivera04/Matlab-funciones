function paste(nd,data)
%PASTE Paste data to a node
%
%  PASTE(NODE,DATA) pastes the given data into the node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:34:22 $

pT = getdata(nd);
cgb = cgbrowser;
d = cgb.getViewData(guid(nd));
if pT.getNumAxes==1
    d.Handles.Editor1D.paste;
else
    d.Handles.Editor2D.paste;
end
