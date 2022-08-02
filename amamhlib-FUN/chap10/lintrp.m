function y=lintrp(xd,yd,x)
%
% y=lintrp(xd,yd,x)
% ~~~~~~~~~~~~~~~~~
% This function performs piecewise linear 
% interpolation through data values stored in 
% xd, yd, where xd values are arranged in 
% nondecreasing order. The function can handle 
% discontinuous functions specified when two
% successive values in xd are equal. Then the 
% repeated xd values are shifted by a tiny 
% amount to remove the discontinuities. 
% Interpolation for any points outside the range 
% of xd is also performed by continuing the line 
% segments through the outermost data pairs.
%
% xd,yd - data vectors defining the 
%         interpolation
% x     - matrix of values where interpolated 
%         values are required
%
% y     - matrix of interpolated values
%
% NOTE:  This routine is dependent on MATLAB
%        Version 5.x function interp1q.  A
%        Version 4.x solution can be created
%        by renaming routine lntrp.m to
%        lintrp.
%
%----------------------------------------------

xd=xd(:); yd=yd(:); [nx,mx]=size(x); x=x(:);
xsml=min(x); xbig=max(x);
if xsml<xd(1)
 ydif=(yd(2)-yd(1))*(xsml-xd(1))/(xd(2)-xd(1));
 xd=[xsml;xd]; yd=[yd(1)+ydif;yd];
end
n=length(xd); n1=n-1;
if xbig>xd(n)
  ydif=(yd(n)-yd(n1))*(xbig-xd(n))/ ...
       (xd(n)-xd(n1));
  xd=[xd;xbig]; yd=[yd;yd(n)+ydif];
end
k=find(diff(xd)==0);
if length(k)~=0
  n=length(xd);
  xd(k+1)=xd(k+1)+(xd(n)-xd(1))*1e3*eps;
end
y=reshape(interp1q(xd,yd,x),nx,mx);
