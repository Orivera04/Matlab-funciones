function [v,c]=spterp(xd,yd,id,x,endv,c)
% [v,c]=spterp(xd,yd,id,x,endv,c)

% This function performs cubic spline interpo-
% lation. Values of y(x),y'(x),y''(x) or the
% integral(y(t)*dt, xd(1)..x) are obtained.
% xd, yd - data vectors with xd arranged in
%          ascending order. 
% id     - id equals 0,1,2,3 to compute y(x),
%          y'(x), integral(y(t)*dt,t=xd(1)..x),
%          respectively.
% v      - values of the function, first deriva-
%          tive, second derivative, or integral
%          from xd(1) to x
% c      - the coefficients defining the spline
%          curve.
% endv   - vector giving the end conditions in
%          one of the following five forms:
%          endv=1 or endv omitted makes
%            c(2) and c(n-1) zero
%          endv=[2,left_end_slope,...
%            right_end_slope] to impose slope
%            values at each end
%          endv=[3,left_end_slope] imposes the
%            left end slope value and makes
%            c(n-1) zero
%          endv=[4,right_end_slope] imposes the
%            right end slope value and makes
%            c(2) zero
%          endv=5 defines a periodic spline by
%            making y,y',y" match at both ends

if nargin<5 | isempty(endv), endv=1; end
n=length(xd); sx=size(x); x=x(:); X=x-xd(1); 

if nargin<6, c=spcof(xd,yd,endv); end

C=c(1:n); s1=c(n+1); m1=c(n+2); X=x-xd(1);  

if id==0      %  y(x)
	v=yd(1)+s1*X+m1/2*X.*X+...
	  powermat(x,xd,3)*C/6;
elseif id==1  % y'(x)
    v=s1+m1*X+powermat(x,xd,2)*C/2;
elseif id==2  % y''(x)
	v=m1+powermat(x,xd,1)*C;
else          % integral(y(t)*dt, t=xd(1)..x)
	v=yd(1)*X+s1/2*X.*X+m1/6*X.^3+...
		powermat(x,xd,4)*C/24;
end
v=reshape(v,sx);

%==============================================

function c=spcof(x,y,endv)
% c=spcof(x,y,endv)
% This function determines spline interpolation
% coefficients consisting of the support
% reactions concatenated with y' and y'' at
% the left end.
% x,y  - data vectors of interplation points.
%        Denote n as the length of x.
% endv - vector of data for end conditions 
%        described in function spterp.
%
% c   -  a vector [c(1);...;c(n+2)] where the
%        first n components are support 
%        reactions and the last two are 
%        values of y'(x(1)) and y''(x(1)).

if nargin<3, endv=1; end
x=x(:); y=y(:); n=length(x); u=x(2:n)-x(1);
a=zeros(n+2,n+2); a(1,1:n)=1; 
a(2:n,:)=[powermat(x(2:n),x,3)/6,u,u.*u/2];
b=zeros(n+2,1); b(2:n)=y(2:n)-y(1);
if endv(1)==1     % Force, force condition
  a(n+1,2)=1; a(n+2,n-1)=1;
elseif endv(1)==2 % Slope, slope condition
  b(n+1)=endv(2); a(n+1,n+1)=1; 
  b(n+2)=endv(3); a(n+2,:)=...
		[((x(n)-x').^2)/2,1,x(n)-x(1)];
elseif endv(1)==3 % Slope, force condition
  b(n+1)=endv(2); a(n+1,n+1)=1; a(n+2,n-1)=1;
elseif endv(1)==4 % Force, slope condition
  a(n+1,2)=1; b(n+2)=endv(2);
  a(n+2,:)=[((x(n)-x').^2)/2,1,x(n)-x(1)];
elseif endv(1)==5
  a(n+1,1:n)=x(n)-x'; b(n)=0;
  a(n+2,1:n)=1/2*(x(n)-x').^2;
  a(n+2,n+2)=x(n)-x(1);
else    
  error(...
  'Invalid value of endv in function spcof')
end
if endv(1)==1 & n<4, c=pinv(a)*b;
else, c=a\b; end

%==============================================

function a=powermat(x,X,p)
% a=powermat(x,X,p)
% This function evaluates various powers of a
% matrix used in cubic spline interpolation.
%
% x,X  - arbitrary vectors of length n and N
% a    - an n by M matrix of elements such that
%        a(i,j)=(x(i)>X(j))*abs(x(i)-X(j))^p
x=x(:); n=length(x); X=X(:)'; N=length(X);
a=x(:,ones(1,N))-X(ones(n,1),:); a=a.*(a>0);
switch p, case 0, a=sign(a); case 1, return;
case 2, a=a.*a; case 3; a=a.*a.*a;
case 4, a=a.*a; a=a.*a; otherwise, a=a.^p; end