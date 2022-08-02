function dG= delknot(f,i)
% LOCALTRUNCPS/DELKNOT partial derivative for natural knots

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:29:45 $

c= get(f,'code');
p= double(f);
dG= zeros(1,length(p));
if isempty(c.g)
   dG(i)= (c.max-c.min)/c.range;
else
   % deal with x transformation
   ginv= inline(diff(finverse(sym(c.g))));
   dG(i)= ginv(p(i))*(c.g(c.max)-c.g(c.min))/c.range;
end   
