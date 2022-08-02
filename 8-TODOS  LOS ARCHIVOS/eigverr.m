function eigverr(nfd,nspl,kseg)
% eigverr(nfd,nspl,kseg)
% This function compares two methods of computing 
% eigenvalues corresponding to
%
% y"(x)+w^2*y(x)=0, y(0)=y(1)=0.
%
% Results are obtained using 1) finite differences
% and 2) cubic splines.
%
% nfd -  number of interior points used for the 
%        finite difference equations
% nspl - number of interior points used for the
%        spline functions.
% kseg - the number of interior spline points is
%        kseg*(nspl+1)+nspl

if nargin==0, nfd=100; nspl=100; kseg=4; end
[ws,es]=spleig(nspl,kseg); [wd,ed]=findieig(nfd);
str=['COMPARING TWO METHODS FOR EIGENVALUES ',...
     'OF Y"(X)+W^2*Y(X)=0, Y(0)=Y(1)=0'];
close; plot(1:nspl,es,'k-',1:nfd,ed,'k.')
title(str), xlabel('Eigenvalue Index')
ylabel('Percent Error'), Nfd=num2str(nfd);
Ns=num2str(nspl); M=num2str(nspl+(nspl+1)*kseg);
legend(['Using ',Ns,' cubic splines and ',...
         M,' least square points'],...
  ['Using ',Nfd,' finite differences points'],3)
grid on, shg
% print -deps eigverr

%==========================================

function [w,pcterr]=findieig(n)
% [w,pcterr]=findieig(n)
% This function determines eigenvalues of
% y''(x)+w^2*y(x)=0, y(0)=y(1)=0
% The solution uses an n point finite
% difference approximation
if nargin==0, n=100; end
a=2*eye(n,n)-diag(ones(n-1,1),1)...
  -diag(ones(n-1,1),-1);
w=(n+1)*sqrt(sort(eig(a))); we=pi*(1:n)';
pcterr=100*(w-we)./we; 

%==========================================

function [w,pcterr]=spleig(n,nseg)
% [w,pcterr]=spleig(n,nseg)
% This function determines eigenvalues of
% y''(x)+w^2*y(x)=0, y(0)=y(1)=0
% The solution uses n spline basis functions
% and nseg*(n+1)+n least square points

if nargin==0, n=100; nseg=1; end
nls=(n+1)*nseg+n; xls=(1:nls)'/(nls+1);
a=zeros(nls,n); b=a; 
for k=1:n
  a(:,k)=splnf(k,n,1,xls,2); 
  b(:,k)=splnf(k,n,1,xls);
end
w=sqrt(sort(eig(-b\a))); we=pi*(1:n)';
pcterr=100*(w-we)./we; 

%==========================================

function y=splnf(n,N,len,x,ideriv)
% y=splnf(n,N,len,x,ideriv)
% This function computes the spline basis
% functions and derivatives
xd=len/(N+1)*(0:N+1)'; yd=zeros(N+2,1);
yd(n+1)=1; 
if nargin<5, y=spline(xd,yd,x);
elseif ideriv==1, y=splined(xd,yd,x);
else, y=splined(xd,yd,x,2); end

%==========================================

% function val=splined(xd,yd,x,if2)
% See Appendix B