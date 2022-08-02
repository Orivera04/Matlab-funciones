function [x,y]= symmetric(ps,x,y);
% localpspline/SYMMETRIC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:40 $

%[x,y]= NewSym(ps,x,y);
%return

m = (x > ps.knot);
nm= sum(m);
if nm<ps.order(1)
   % rhs
   x= [x ; ps.knot-(x(~m)-ps.knot)];
   if nargin==3
      y= [y ; y(~m)];
   end
elseif length(x)-nm<ps.order(2)
   % lhs
   x= [x ; ps.knot-(x(m)-ps.knot)];
   if nargin==3
      y= [y ; y(m)];
   end
end
return


function [x,y]= NewSym(ps,x,y)
% possible new symmetry algorithm 

m = (x > ps.knot);
% Assume symmetry in J if all(m) | all(~m)
% This is equivalent to adding mirror image points wrt ps.knot
nx= length(x);

Nm= sum(m);
if Nm < ps.order(1)
   % not enough points above knot
   
   % just flip enough points to make J full rank
   [Xnew,ind]= sort(ps.knot-(x(~m)-ps.knot));  
   
   Nf= ps.order(1)-Nm;
   Xnew= Xnew(1:Nf);
   
   x= [x ; Xnew];
   if nargin==3
      y= [y ; y(ind(1:Nf)) ];
   end
   
elseif nx-Nm < ps.order(2)
   % not enough points below knot
   
   % just take closest points
   [Xnew,ind]= sort((x(m)-ps.knot));
   Xnew= ps.knot-Xnew;  
   
   Nf= ps.order(2)-(nx-Nm);
   Xnew= Xnew(1:Nf);
   
   x= [x ; Xnew];
   if nargin==3
      y= [y ; y(ind(1:Nf)) ];
   end
end
