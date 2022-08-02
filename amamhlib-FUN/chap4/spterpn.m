function [errmat]=runspline(nd)
% errmat=runspline(nd)
% Test spline interpolation for various end conditions
% using function spterp
disp(' ')
disp('SPLINE INTERPOLATION ERROR TEST')
disp(' ')

% Make some random polynomial data
if nargin==0, nd=6; end; xl=1; xr=3; tp=5;
xd=sort(rand(1,nd)); xd=xd-xd(1); xd=xd/max(xd);
xd=xl+(xr-xl)*xd; yd=rand(size(xd)); yd=yd/max(yd);
u=polyfit(xd,yd,length(xd)-1);

% Polynomial and it first two derivatives
f=inline('polyval(u,x)','u','x');
f1=inline('polyval(polyder(u),x)','u','x');
f2=inline('polyval(polyder(polyder(u)),x)','u','x');
maxe=inline('num2str(max(abs(x(:))))');
% End slopes
s=f1(u,[xl,xr]);

% Data for the spline interpolation. Use 100 points
xsd=linspace(xl,xr,100); ysd=f(u,xsd);
xplt=linspace(xl,xr,199);

% Compare exact and spline results

% Neither end slope given
close; endc=1;
er000=spterp(xsd,ysd,0,xplt)-f(u,xplt); e000=maxe(er000); 
t000=['Function error with no end slopes = ',e000];
disp(t000), plot(xplt,er000), title(t000), shg, pause(tp)

er100=spterp(xsd,ysd,1,xplt)-f1(u,xplt); e100=maxe(er100);
t100=['Derivative error with no end slopes = ',e100];
disp(t100), plot(xplt,er100), title(t100), shg, pause(tp)

er200=spterp(xsd,ysd,2,xplt)-f2(u,xplt); e200=maxe(er200);
t200=['Second derivative error with no end slopes = ',e200];
disp(t200), plot(xplt,er200), title(t200), shg, pause(tp)

% Both slopes given
disp(' '), endc=[2,s(1),s(2)];
er011=spterp(xsd,ysd,0,xplt,endc)-f(u,xplt); e011=maxe(er011);
t011=['Function error with both end slopes = ',e011]; 
disp(t011), plot(xplt,er011), title(t011), shg, pause(tp)

er111=spterp(xsd,ysd,1,xplt,endc)-f1(u,xplt); e111=maxe(er111);
t111=['Derivative error with both end slopes = ',e111];
disp(t111), plot(xplt,er111), title(t111), shg, pause(tp)

er211=spterp(xsd,ysd,2,xplt,endc)-f2(u,xplt); e211=maxe(er211);
t211=['Second derivative error with both end slopes = ',e211];
disp(t211), plot(xplt,er211), title(t211), shg, pause(tp)

% Left slope given
disp(' '), endc=[3,s(1)];
er010=spterp(xsd,ysd,0,xplt,endc)-f(u,xplt); e010=maxe(er010);
t010=['Function error with left end slope = ',e010];
disp(t010), plot(xplt,er010), title(t010), shg, pause(tp)

er110=spterp(xsd,ysd,1,xplt,endc)-f1(u,xplt); e110=maxe(er110);
t110=['Derivative error with left end slope = ',e110];
disp(t110), plot(xplt,er110), title(t110), shg, pause(tp)

er210=spterp(xsd,ysd,2,xplt,endc)-f2(u,xplt); e210=maxe(er210);
t210=['Second derivative error with left end slope = ',e210];
disp(t210), plot(xplt,er210), title(t210), shg, pause(tp)

% Right slope given
disp(' '), endc=[4,s(2)];
er001=spterp(xsd,ysd,0,xplt,endc)-f(u,xplt); e001=maxe(er001);
t001=['Function error with right end slope = ',e001];
disp(t001), plot(xplt,er001), title(t001), shg, pause(tp)

er101=spterp(xsd,ysd,1,xplt,endc)-f1(u,xplt); e101=maxe(er101);
t101=['Derivative error with right end slope = ',e101];
disp(t101), plot(xplt,er101), title(t101), shg, pause(tp)

er201=spterp(xsd,ysd,2,xplt,endc)-f2(u,xplt); e201=maxe(er201);
t201=['Second derivative error with right end slope = ',e201];
disp(t201), plot(xplt,er201), title(t201), shg, pause(tp), close

errmat=[er000;er100;er200;er011;er111;er211;er010;...
		er110;er210;er001;er101;er201]';

%=================================================

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
%          one of the following four forms:
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
else
	error(...
	'Invalid value of endv in function spcof')
end
if endv(1)==1 & n<4, 	c=pinv(a)*b;
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