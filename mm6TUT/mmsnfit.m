function [a,b]=mmsnfit(x,y,n)
%MMSNFIT Simple Nonlinear Curve Fit by Transformation. (MM)
% [A,B]=MMSNFIT(x,y,N) performs least squares curve fitting by
% linearizing the data, fitting it to a straight line,
% then inverting the linearization. A and B are the desired 
% curve fit coefficients.
% N identifies the function to be fit:
%
%  N | function     N | function        N | function
%  --+-----------   ------------------  ---------------
%  0 | y= A*x+B     3 | y= 1/(A*x+B)    6 | y= A*x^B
%  1 | y= (A/x)+B   4 | y= 1/(A*x+B)^2  7 | y= A*log(x)+B
%  2 | y= A/(x+B)   5 | y= x/(A*x+B)    8 | y= A*exp(B*x)
%                                       9 | y= A*x*exp(B*x)
% See also MMSNEVAL. 

% Duane Hanselman and Bob Kilmer, University of Maine, Orono, ME,  04469
% 5/18/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3, n=0; end  % default is straight line fit

x=x(:); y=y(:);  % make data columns
if length(x)~=length(y), error('x and y Must be the Same Size.'), end
if length(x)<2, error('At Least 2 Data Points are Required.'), end

xx=x;yy=y;  % default fitting data
if     n==1, xx=1./x;  % transformations
elseif n==2, xx=x.*y; 
elseif n==3, yy=1./y;
elseif n==4, yy=1./sqrt(y);
elseif n==5, xx=1./x; yy=1./y;
elseif n==6, xx=log(x); yy=log(y);
elseif n==7, xx=log(x);
elseif n==8, yy=log(y);
elseif n==9, yy=log(y./x);
elseif n~=0, error('Unknown Function Type Chosen.')
end

p=polyfit(xx,yy,1);

a=p(1); b=p(2); % default a,b
if     n==2, b=-1/p(1); a=b*p(2);
elseif n==5, a=p(2); b=p(1);
elseif n==6, b=p(1); a=exp(p(2));
elseif n==8, b=p(1); a=exp(p(2));
elseif n==9, b=p(1); a=exp(p(2));
end
