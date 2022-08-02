function L=knot_optim_ga(X,m,C,P,alpha,JTgt)
%KNOT_OPTIM_GA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:34 $

%-----------------------global_univariate_spline_fit.m-------------------
% A function to fit the second stage uni-variate spline models.
%
% X 		vector of transformed knot positions
% P 		vector of sweep coefficient values
% order	spline order
% C		vector of covariate values
%-------------------------------------------------------------------------------

k= invjupp(m.mv3xspline,max(X,sqrt(eps)),JTgt);
m.mv3xspline= set(m.mv3xspline,'knots',k);
A= x2fx(m.mv3xspline,C);


%m=fitmodel(xreg3xspline(3,k,xregcubic([]),1,1,'X'),C,P);
%-------------------------------------------------------------------------------
% The following lines of code generate the cost function. I have cunningly
% used the conditional linearity of the problem statement to implement a
% susbtitution mechanism to get rid of the spline coefficients. This means that
% the cost function is only a function of the A matrix (spline basis functions)
% and so the knots. In this way it is never necessary to solve for the coefficients
% directly. 
%
% The interpretation of the cost function is still a sum of squares of residuals
% but I have used a direct transformation of the form:
%
% residuals'*residuals = P'(I-H)^2P, where H=A*inv(A'*A)*A'. Note that (I-H) is
% idempotent so (I-H)^2=(I-H) and H=Q1*Q1' from a QR decompostion of A.
%
% In addition, the basic cost function is multiplied by a penalty function Z
% which has the property that when knots coalesce, Z tends to infinity. Similarly
% as the knots become equi-spaced Z tends to unity. The penalty function is
% taken from a paper by M. J. Lindtrom on free knot spline estimation.

[Q,R]= qr(A,0);
yq= Q'*P;
L= (sum(P.*P)-sum(yq.*yq));
%-------------------------------------------------------------------------------
%-----------------------------------------------------------------
% Calculate the penalty function (Z).
%-------------------------------------------------------------
tgt= gettarget(m);
a=tgt(1);								% calculate lower bound for knots
b=tgt(2);								% calculate upper bound for knots
h=diff([a; k(:); b])./(b-a);				% define normalised knot intervals
h(find(h<=0))=1e-6;					% prevent log of zero error
Z= -alpha*sum(log((length(k)+1)*h))+1;		% calculate penalty
L=Z*L;												% apply penalty
