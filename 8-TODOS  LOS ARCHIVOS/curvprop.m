function [area,leng,X,Y,closed]=curvprop(x,y,doplot)
%
% [area,leng,X,Y,closed]=curvprop(x,y,doplot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function passes a cubic spline curve through
% a set of data values and computes the enclosed 
% area, the curve length, and a set of points on 
% the curve.
%
% x,y    - data vectors defining the curve. 
% doplot - plot the curve if a value is input for
%          doplot. Otherwise, no plot is made.
% area   - the enclosed area is computed. This
%          parameter is valid only if the curve
%          is closed and the boundary is traversed
%          in counterclockwise. For a curve, the
%          area agrees with a curve closed using
%          a line from the last point to the 
%          origin, and a line from the origin to
%          the first point.
% leng   - length of the curve
% X,Y    - set of points on the curve. The output
%          intersperses three points on each segment
%          between the starting data values. 
% closed - equals one for a closed curve. Equals zero
%          for an open curve. 
%

% For default test data, choose an ellipse with 
% semi-diameters of 2 and 1.
if nargin==0 
  m=21; th=linspace(0,2*pi,m);
  x=2*cos(th); y=sin(th); x(m)=2; y(m)=0;
end

% Use complex data coordinates
z=x(:)+i*y(:); n=length(z); t=(1:n)';
chord=sum(abs(diff(z))); d=abs(z(n)-z(1));

% Use a periodic spline if the curve is closed
if d < (chord/1e6)
  closed=1; z(n)=z(1); endc=5;
  zp=spterp(t,z,1,t,endc);
  
% Use the not-a-knot end condition for open curve  
else
  closed=0; endc=1; zp=spterp(t,z,1,t,endc);
end

% Compute length and area
% plot(abs(zp)),shg,pause
leng=spterp(t,abs(zp),3,n,1);
area=spterp(t,1/2*imag(conj(z).*zp),3,n,1);
Z=spterp(t,z,0,1:1/4:n,endc);
X=real(Z); Y=imag(Z);
if nargin>2
  close; plot(X,Y,'-',x,y,'.'), axis equal
  xlabel('x axis'), ylabel('y axis')
  title('SPLINE CURVE'), shg
end

%============================================

function [v,c]=spterp(xd,yd,id,x,endv,c)
%
% [v,c]=spterp(xd,yd,id,x,endv,c)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function performs cubic spline interpo-
% lation. Values of y(x),y'(x),y''(x) or the
% integral(y(t)*dt, xd(1)..x) are obtained.
% Five types of end conditions are provided.
%
% xd, yd - data vectors with xd arranged in
%          ascending order. 
% id     - id equals 0,1,2,3 to compute y(x),
%          y'(x), integral(y(t)*dt,t=xd(1)..x),
%          respectively.
% v      - values of the function, first deriva-
%          tive, second derivative, or integral
%          from xd(1) to x
% c      - the coefficients defining the spline
%          curve. If these values are input from
%          an earlier computation, then they 
%          are not recomputed.
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
%
% c=spcof(x,y,endv)
% ~~~~~~~~~~~~~~~~
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
%
% a=powermat(x,X,p)
% ~~~~~~~~~~~~~~~~
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
