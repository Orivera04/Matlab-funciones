function [LB,UB,A,c,nlc,alpha]= constraints(bs,X,Y,B)
%xregUniSpline/CONSTRAINTS - returns parameters for optimisation
%
% [lb, ub,A,b,nlc,alpha]= constraints(m,X,Y) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:02 $

Ns= size(X,3);
nk= get(bs.xreg3xspline,'numknots');
knots= get(bs.xreg3xspline,'knots');
alpha= zeros(Ns,1);

Tgt=gettarget(bs,1);
TOL= sqrt(eps)*max(abs(Tgt));

LB= zeros(nk,Ns);
UB=LB;

for i=1:Ns
   
   Xs= sort(X{i});
   if nargin>3
      bs= update(bs,B(:,i));
      knots= get(bs.xreg3xspline,'knots');
   end
   
   % penalty coeff
   h=diff([Tgt(1),knots(:)',Tgt(2)])/(Tgt(2)-Tgt(1));
   div= (sum(log((nk+1)*h)));
   if div<0.01
      alpha(i)= -0.1/div;
   else
      alpha(i)= -0.1/0.01;      
   end
   
   % Bounds
   LB(:,i)= max(Xs(3),Tgt(1))+TOL;
   UB(:,i)= min(Tgt(2),Xs(end-2))-TOL ;
   
end

alpha(~isfinite(alpha))=-0.1;

% no linear constraints
A= [];
c= [];

% number of nonlinear constraints
nlc= 0;
