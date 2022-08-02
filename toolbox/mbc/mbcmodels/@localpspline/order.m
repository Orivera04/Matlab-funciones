function N= order(ps);
% localpspline/ORDER order of localpspline
%
% At the moment a single number is returned
%   ps.order(2)*10+ps.order(1);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:28 $

N= ps.order(2)*10+ps.order(1);