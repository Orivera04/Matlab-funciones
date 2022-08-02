function pItms = getprimaryitems(nd)
%GETPRIMARYITEMS Return a list of the node's primary items
%
%  PTRS = GETPRIMARYITEMS(NODE) returns a (1xn) xregpointer array
%  containing pointers to the primary items for this node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 08:37:42 $ 


% Tradeoffnode itself contains all of the functionality and there is no
% primary item belonging to the node.
pItms = null(xregpointer, 0);