function n=name(ps)
% localpspline/NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:27 $

n= sprintf('PS%1d%1d',ps.order([2 1]));
