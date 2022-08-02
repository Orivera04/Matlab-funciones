function pItms = getprimaryitems(nd)
%GETPRIMARYITEMS Return a list of the node's primary items
%
%  PTRS = GETPRIMARYITEMS(NODE) returns a (1xn) xregpointer array
%  containing pointers to the primary items for this node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:22:50 $ 


if issubfeature( nd )
    % this is a subfeature, hence has no primary item
    pItms = assign(xregpointer, []);
else
    % Primary item is the top-level feature
    pItms = getdata(nd);
end