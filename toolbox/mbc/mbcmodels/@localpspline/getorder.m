function ord=getorder(p)
% GETORDER  Get low and high spline orders
%
%  ORD=GETORDER(P) returns a two element vector containing
%  the low and then the high polynomila orders.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:12 $

% Created 30/3/2000

ord=p.order;
return