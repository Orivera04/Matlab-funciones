function out=islinear(con)
%ISLINEAR  indicate if constraint is linear
%
%   A Boolean constraint object is only linear if it is a 'Not' constraint
%   and the embedded constraint object is linear.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:31 $ 

if con.Not && strcmpi( con.Op, 'None' ),
    out = islinear( con.Constraints{1} );
else,
    out = 0;
end
