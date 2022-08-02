function [X,Y]=curv2d(xd,yd,nseg,icrnr)
% [X,Y]=curv2d(xd,yd,nseg,icrnr)
if nargin<4, icrnr=[]; end
if nargin<3, nseg=10; end
if nargin==0
  zd=exp(i*linspace(0,2*pi,9)');  
  xd=real(zd); yd=imag(zd);
end
close
zd=xd(:)+i*yd(:); n=length(zd); 
tol=sum(abs(diff(zd)))/1e10; 
if abs(zd(1)-zd(end))<tol, closed=1;
else, closed=0; end
N=[1;sort(icrnr(:));n]; Z=zd(1);
for k=1:length(N)-1
  zk=zd(N(k):N(k+1)); sk=length(zk)-1;
  if sk>0
    s=linspace(0,sk,1+sk*nseg)';
    Zk=spline(0:sk,zk,s); Z=[Z;Zk(2:end)];
  end
end
X=real(Z); Y=imag(Z);
if nargin==0, plot(xd,yd,'o',X,Y,'.'), axis equal, shg; end