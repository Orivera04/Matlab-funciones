function y=lintrp(xd,yd,x)
%
% y=lintrp(xd,yd,x)
% ~~~~~~~~~~~~~~~~~
% This function performs piecewise linear 
% interpolation through data values stored in 
% xd, yd, where xd values are arranged in 
% nondecreasing order. The function can handle 
% discontinuous functions specified when some
% successive values in xd are equal. Then the 
% repeated xd values are shifted by a small 
% amount to remove the discontinuities. 
% Interpolation for any points outside the range 
% of xd is also performed by continuing the line 
% segments through the outermost data pairs.
%
% xd,yd - vectors of interpolation data values
% x     - matrix of values where interpolated 
%         values are required
%
% y     - matrix of interpolated values

k=find(diff(xd)==0);
if length(k)~=0
  xd(k+1)=xd(k+1)+(xd(end)-xd(1))*1e3*eps;
end
y=interp1(xd,yd,x,'linear','extrap');