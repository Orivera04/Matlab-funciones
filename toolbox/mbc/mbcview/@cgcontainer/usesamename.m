function out = usesamename(obj1, obj2)
%USESAMENAME Check whether two nodes should be allowed the same name
%
%  OUT = USESAMENAME(NODE1, NODE2) checks whether it is safe for NODE1 and
%  NODE2 to have the same name.  In most cases this is equivalent to
%  checking that the underlying data is the same or the nodes are the same.
%  NODE1 and NODE2 should be container nodes that contain a pointer to
%  data.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 08:22:04 $ 


P1 = address(obj1);
P2 = address(obj2);

if P1==P2
    out = true;
elseif ~isequal(typeobject(obj1),typeobject(obj2))
    out = false;
else
    % Check contained data
    data1 = getdata(obj1);
    data2 = getdata(obj2);
    if data1==data2
        out = true;
    else
        out = false;
    end
end