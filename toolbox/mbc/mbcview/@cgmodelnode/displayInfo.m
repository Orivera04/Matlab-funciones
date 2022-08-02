function [node, changes] = displayInfo(node);
%DISPLAYINFO Displays model information in a properties dialog
%
%  [node, changed] = DISPLAYINFO(node) opens the properties dialog for the
%  model contained in node.  If changes are made, the node is updated and
%  changed is returned as "true".

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $

pModExpr = getdata(node);
h = xregGui.propertyDialog('Object', pModExpr.info, ...
    'Title', 'Model Properties');

changes = h.show;
if changes
    pModExpr.info = h.Object;
end

delete(h);
