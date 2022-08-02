function pItms = getprimaryitems(nd)
%GETPRIMARYITEMS Return a list of the node's primary items
%
%  PTRS = GETPRIMARYITEMS(NODE) returns a (1xn) xregpointer array
%  containing pointers to the primary items for this node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 08:25:35 $ 


% Primary item is the normalizer only if this node is directly beneath the
% project, not beneath a table
if address(project(nd))==Parent(nd)
    pItms = getdata(nd);
else
    pItms = assign(xregpointer, []);
end