function q=setorder(p,ord)
% SETORDER  Set polynomial order
%
%   P=SETORDER(P,ORD) sets the polynomial order to ORD
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:47 $

% Created 30/3/2000

% changing order implies we need to redo response features, so
% a new model is created with the correct order

if ord~=order(p);
	
	p.xreglinear= update(p.xreglinear,ones(ord+1,1));
	q= SetFeat(p,'default');

else
   q=p;
end
return