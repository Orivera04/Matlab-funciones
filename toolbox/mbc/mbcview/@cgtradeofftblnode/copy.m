function data=copy(nd)
% COPY  Return copied data from node
%
%  DATA=COPY(NODE) returns copied data from a node.  This may
%  be string or numeric data.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:38:55 $

c = cgbrowser;
d = c.getViewData(guid(nd));
d.GUI.TableView.copy;
data = [];