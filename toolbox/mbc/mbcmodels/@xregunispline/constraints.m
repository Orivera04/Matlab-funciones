function [LB, UB,A,c,nlc,alpha]= constraints(m,X,Y,varargin)
%xregUniSpline/CONSTRAINTS - returns parameters for optimisation
%
% [lb, ub,,A,b,nlc,alpha]= constraints(m,X,Y) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:19 $

knots= get(m.mv3xspline,'knots');
Xs= sort(X);

nk= length(knots);
lb= Xs(3)*(1+sqrt(eps));
ub= Xs(end-2)*(1-sqrt(eps));
% set up order constraints
if nk>1
   % diag and - superdiag for difference constraints
   A= diag(ones(1,nk))-diag(ones(1,nk-1),1);
   % last constraint is lower bound
   A(end+1,1)= -1;
else
   % just upper and lower bounds
   A= [1;-1];
end
% last constraints are upper and lower bounds
c= [-sqrt(eps)*ones(nk-1,1);ub;-lb];

LB=lb(ones(nk,1));
UB=ub(ones(nk,1));

Tgt= gettarget(m,1);
h=diff([-1,sort(knots),1])/(Tgt(2)-Tgt(1));
alpha= -0.1/(sum(log((nk+1)*h)));
if ~isfinite(alpha)
   alpha=-0.1;
end

% number of nonlinear constraints
nlc= 0;