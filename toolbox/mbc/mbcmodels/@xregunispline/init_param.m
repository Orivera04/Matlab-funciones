function [lb, ub, alpha]= init_param(m,X,Y)
%xregUniSpline/INIT_PARAM - returns parameters for optimisation
%
% [knots,lbound, ubound, alpha]= init_param(m,X,Y) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:30 $

knots= get(m.mv3xspline,'knots');
Xs= sort(X);

n= length(knots);
lb= Xs(3);
ub= Xs(end-2);

lb= repmat(lb,n,1);
ub= repmat(ub,n,1);

h=diff([-1,knots,1])/2;
alpha= 0.1/(-sum(log((length(knots)+1)*h)));
