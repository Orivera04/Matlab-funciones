function [B,MINB,MAXB,OK] = initial(ps,Xs,Ys);
% localpspline/INITIAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:17 $

MINB=[];
MAXB=[];
% try fitting quadratic
p0=localpoly([1 1 1],[],[]);
[p,OK]= leastsq(p0,Xs,Ys);
if OK
   switch DatumType(ps)
   case 2
      [tm,Knot]=min(p);
   otherwise
      [tm,Knot]=max(p);
   end
   OK=  ~isempty(Knot);
end
if OK
   bp= double(p);
   ps.knot=Knot;
   ps.polyhigh= [zeros(1,ps.order(1)-2) bp(1) 0 tm];
   ps.polylow= [zeros(1,ps.order(2)-2) bp(1) 0 tm];
   B= double(ps);
else
   B= zeros(size(ps,1),1);
end
