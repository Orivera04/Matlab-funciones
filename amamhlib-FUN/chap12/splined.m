function val=splined(xd,yd,x,if2)
%
% val=splined(xd,yd,x,if2)
% ~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function evaluates the first or second 
% derivative of the piecewise cubic 
% interpolation curve defined by the intrinsic 
% function spline provided in MATLAB.If fewer
% than four data points are input, then simple
% polynomial interpolation is employed
%
% xd,yd - data vectors determining the spline
%         curve produced by function spline
% x     - vector of values where the first or
%         the second derivative are desired
% if2   - a parameter which is input only if 
%         y''(x) is required. Otherwise, y'(x)
%         is returned.
%
% val   - the first or second derivative values
%         for the spline
%
% User m functions called: none

n=length(xd); [b,c]=unmkpp(spline(xd,yd)); 
if n>3 % Use a cubic spline
  if nargin==3, c=[3*c(:,1),2*c(:,2),c(:,3)];
  else, c=[6*c(:,1),2*c(:,2)]; end
  val=ppval(mkpp(b,c),x);  
else % Use a simple polynomial
  c=polyder(polyfit(xd(:),yd(:),n-1));
  if nargin==4, c=polyder(c); end
  val=polyval(c,x);
end