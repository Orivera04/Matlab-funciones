function y=mmsneval(x,a,b,n)
%MMSNEVAL Simple Nonlinear Curve Fit Evaluation. (MM)
% MMSNEVAL(x,A,B,N) evaluates a fitted nonlinear function
% from MMSNFIT at the points in x, given the coefficients
% A and B. N identifies the function to be evaluated:
%
%  N | function     N | function        N | function
%  --+-----------   ------------------  ---------------
%  0 | y= A*x+B     3 | y= 1/(A*x+B)    6 | y= A*x^B
%  1 | y= (A/x)+B   4 | y= 1/(A*x+B)^2  7 | y= A*log(x)+B
%  2 | y= A/(x+B)   5 | y= x/(A*x+B)    8 | y= A*exp(B*x)
%                                       9 | y= A*x*exp(B*x)
% See also MMSNFIT.

% Duane Hanselman and Bob Kilmer, University of Maine, Orono, ME,  04469
% 5/18/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if     n==0, y=a*x+b;
elseif n==1, y=(a./x)+b;
elseif n==2, y=a./(x+b);
elseif n==3, y=1./(a*x+b);
elseif n==4, y=(a*x+b).^(-2);
elseif n==5, y=x./(a*x+b);
elseif n==6, y=a*x.^b;
elseif n==7, y=a*log(x)+b;
elseif n==8, y=a*exp(b*x);
elseif n==9, y=a*x.*exp(b*x);
else, error('Unknown Function Type Chosen.')
end
