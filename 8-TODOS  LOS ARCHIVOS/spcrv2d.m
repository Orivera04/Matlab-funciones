function [X,Y]=spcrv2d(xd,yd,nseg,icrnr)
%
% [X,Y]=spcrv2d(xd,yd,nseg,icrnr)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes points (X,Y) on a
% spline curve through (xd,yd) allowing slope
% discontinuities at points with corner 
% indices in icrnr. nseg plot segments are 
% used between each successive pair of points.

if nargin<4, icrnr=[]; end
if nargin<3, nseg=10; end
zd=xd(:)+i*yd(:); n=length(zd); 
N=[1;sort(icrnr(:));n]; Z=zd(1);
if N(1)==N(2); N(1)=[]; end
if N(end)==N(end-1); N(end)=[]; end
for k=1:length(N)-1
  zk=zd(N(k):N(k+1)); sk=length(zk)-1;
  s=linspace(0,sk,1+sk*nseg)';
  Zk=spline(0:sk,zk,s); Z=[Z;Zk(2:end)];
end
X=real(Z); Y=imag(Z);