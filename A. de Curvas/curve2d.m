function [z,zplot,zp]=curve2d(xd,yd,kn,t)
%
% [z,zplot,zp]=curve2d(xd,yd,kn,t)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function generates a spline curve through
% given data points with corners(slope dis-
% continuities) allowed as selected points.
% xd,yd - real data vectors of length nd 
%         defining the curve traversed in 
%         counterclockwise order. 
% kn    - vectors of point indices, between one
%         and nd, where slope discontinuities
%         occur
% t     - a vector of parameter values at which 
%         points on the spline curve are 
%         computed. The components of t normally
%         range from one to nd, except when t is
%         a negative integer,-m. Then t is 
%         replaced by a vector of equally spaced 
%         values using m steps between each 
%         successive pair of points.
% z     - vector of points on the spline curve
%         corresponding to the vector t
% zplot - a complex vector of points suitable
%         for plotting the geometry
% zp    - first derivative of z with respect to
%         t for the same values of t as is used
%         to compute z
%
% User m functions called:  splined
%----------------------------------------------

nd=length(xd); zd=xd(:)+i*yd(:); td=(1:nd)';
if isempty(kn), kn=[1;nd]; end 
kn=sort(kn(:)); if kn(1)~=1, kn=[1;kn]; end
if kn(end)~=nd, kn=[kn;nd]; end
N=length(kn)-1; m=round(abs(t(1))); 
if -t(1)==m, t=linspace(1,nd,1+N*m)'; end
z=[]; zp=[]; zplot=[];
for j=1:N
  k1=kn(j); k2=kn(j+1); K=k1:k2;
  k=find(k1<=t & t<k2);
  if j==N, k=find(k1<=t & t<=k2); end
  if ~isempty(k)
    zk=spline(K,zd(K),t(k)); z=[z;zk];
    zplot=[zplot;zd(k1);zk];
    if nargout==3
      zp=[zp;splined(K,zd(K),t(k))];
    end
  end
end
zplot=[zplot;zd(end)];

%============================================

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