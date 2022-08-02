function out=islinear(con)
%ISLINEAR  Indicate if constraint is linear
%
%   A two-stage constraint object is only linear if the local boundary
%   constraint is linear and all of the global models are linear.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:43 $ 

out = islinear( con.Local );
for i = 1:numel( con.Global ),
    out = out && islinear( con.Gobal{i} );
end
