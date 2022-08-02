function paste(nd,data)
% PASTE  Paste data to a node
%
%  PASTE(NODE,DATA) pastes the given data into the node.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:39:01 $

c = cgbrowser;
d = c.getViewData(guid(nd));
d.GUI.TableView.paste;
