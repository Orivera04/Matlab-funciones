function q=setorder(p,ord)
% SETORDER  Set low and high spline orders
%
%  P=SETORDER(P,ORD) sets the localpspline model P to have orders
%  ORD.  ORD is a two element vector containing the low and high 
%  spline orders.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:34 $

% Created 30/3/2000

if ord~=order(p)
	
	p.knot     = 0;
   p.order    = ord;
   p.polylow  = [ones(1,ord(2)-1) 0 1];
   p.polyhigh = [ones(1,ord(1)-1) 0 1];
	
	q= SetFeat(p,'default');

else
   q=p;
end
return