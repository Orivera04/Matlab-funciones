function ret=cancopy(nd)
%CANCOPY Indicate whether node can copy data
%
%  OUT=CANCOPY(NODE)  return value is non-zero if the node is currently in
%  a state to return copied data.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:34:17 $

pT = getdata(nd);
cgb = cgbrowser;
d = cgb.getViewData(guid(nd));
if pT.getNumAxes==1
    ret = d.Handles.Editor1D.canCopy;
else
    ret = d.Handles.Editor2D.canCopy;
end
