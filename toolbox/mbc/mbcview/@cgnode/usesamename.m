function out = usesamename(obj1, obj2)
%USESAMENAME Check whether two nodes should be allowed the same name
%
%  OUT = USESAMENAME(NODE1, NODE2) checks whether it is safe for NODE1 and
%  NODE2 to have the same name.  In most cases this is equivalent to
%  checking that the underlying data is the same or the nodes are the same.
%  NODE1 and NODE2 should be nodes of the same type - this method is not
%  designed to handle dissimilar objects.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 08:25:21 $ 


P1 = address(obj1);
P2 = address(obj2);

if P1==P2
    out = true;
else
    out = false;
end