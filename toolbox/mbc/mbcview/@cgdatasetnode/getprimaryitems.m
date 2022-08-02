function pItms = getprimaryitems(nd)
%GETPRIMARYITEMS Return a list of the node's primary items
%
%  PTRS = GETPRIMARYITEMS(NODE) returns a (1xn) xregpointer array
%  containing pointers to the primary items for this node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:21:48 $ 


% Primary item is the dataset
pItms = getdata(nd);

