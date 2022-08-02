function runspleig(N,m)
% runspleig(N,m)
if nargin==0, N=100; m=1; end
n=(1:N)'; m=1; w=zeros(N,m); we=pi*n*ones(1,m);
for k=1:m; w(:,k)=spleig(N,k*N); end
plot(n,(w-we)./we), grid on, shg

function [w,pcterr]=spleig(n,nls)
% [w,pcterr]=spleig(n,nls)
% This function determines eigenvalues of
% y''(x)+w^2*y(x)=0, y(0)=y(1)=0
% The solution uses n spline basis functions
% and nls least square points
if nargin==0, n=100; nls=4*n; end
xls=(1:nls)'/(nls+1); a=zeros(nls,n); b=a;
for k=1:n
  a(:,k)=splnf(k,n,1,xls,2); 
  b(:,k)=splnf(k,n,1,xls);
end
w=sqrt(sort(eig(-b\a))); we=pi*(1:n)';
pcterr=100*(w-we)./we; 

%==========================================

function y=splnf(n,N,len,x,ideriv)
% y=splnf(n,N,len,x,ideriv)
xd=len/(N+1)*(0:N+1)'; yd=zeros(N+2,1);
yd(n+1)=1; 
if nargin<5, y=spline(xd,yd,x);
elseif ideriv==1, y=splined(xd,yd,x);
else, y=splined(xd,yd,x,2); end