function s = guid(h, pSub)
%GUID Return globally unique identifier 
%
%  STR = GUID(NODE, pSUB) returns a string that uniquely identifies this
%  node's browser view.  pSUB is a pointer to the sub item that the view
%  will be displaying.  If pSUB is omitted it is assumed that this is
%  equivalent to pSUB being a null xregpointer.
%
%  NODE = GUID(NODE, STR) sets a new guid string in the node object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:25:00 $


if nargin>1 && ischar(pSub)
    h.GUID = pSub;
    s = h;
    xregpointer(h);
else
    s = h.GUID;
end
