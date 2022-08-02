function data=copy(nd)
%COPY Provide copy data for cgbrowser
%
%  DATA = COPY(NODE) returns data that should be copied from the browser
%  view to the clipboard.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:34:19 $

pT = getdata(nd);
cgb = cgbrowser;
d = cgb.getViewData(guid(nd));
if pT.getNumAxes==1
    d.Handles.Editor1D.copy;
else
    d.Handles.Editor2D.copy;
end

% We need to pass back something.
data = [];
