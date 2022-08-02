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

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:37:49 $

if nargin==2 && ~ischar(pSub)
    if isnull(pSub)
        % Present self as standard tradeoff setup view
        s = guid(h.cgnode);
    else
        % Present self as inputs list view
        s = 'cgtradeofflistview';
    end
    
elseif nargin==2
    s = guid(h.cgnode, pSub);
else
    s = guid(h.cgnode);
end

