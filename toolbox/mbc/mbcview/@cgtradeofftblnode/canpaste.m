function ret=canpaste(nd,data)
% CANPASTE  Indicate whether node can paste data
%
%  OUT=CANPASTE(NODE,DATA)  returns 1/0 to indicate whether the node
%  is currently in a state to paste in the given data.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:38:52 $

c = cgbrowser;
d = c.getViewData(guid(nd));
ret = d.GUI.TableView.canpaste;
