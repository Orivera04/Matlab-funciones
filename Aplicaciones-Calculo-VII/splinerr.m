function splinerr      
% Example: splinerr
% ~~~~~~~~~~~~~~~~~
%
% This program calculates the binormal and
% curvature error for a spiral space curve.
%
% User m functions called:
% aspiral, crvprpsp crvprp3d cubrange splined
%--------------------------------------------

clear; hold off; close
[R,T,N,B,KAP]=aspiral; m=size(R,2);
[r,t,n,b,k]=crvprpsp(R,m); 
disp(' '); disp(...
'Press [Enter] to show error curves'); pause  
errv=sqrt(sum((B-b).^2)); 
errk=abs((KAP-k)./KAP); hold off; clf;
semilogy(1:m,errv,'k-',1:m,errk,'k--');
xlabel('point index'); ylabel('error measure');
title('Error Plot');
legend('Binormal error','Curvature error',3);
figure(gcf); disp(' ')
disp('Press [Enter] to finish'); pause
disp(' '), disp('All done'), disp(' ') 

%==============================================

function [R,T,N,B,kap,tau,arclen]= ...
                             aspiral(r0,k,h,t)
%                           
% [R,T,N,B,kap,tau,arclen]=aspiral(r0,k,h,t)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes geometrical properties
% of a spiral curve having the parametric 
% equation
%
%   R = [(r0+k*t)*cos(t);(r0+k*t)*sin(t);h*t]
%
% A figure showing the curve along with the 
% osculating plane and the rectifying plane 
% at each point is also drawn.
%
% r0,k,h - parameters which define the spiral
% t      - a vector of parameter values at 
%          which the curve is evaluated from 
%          the parametric form.
% 
% R      - matrix with columns containing 
%          position vectors for points on the 
%          curve
% T,N,B  - matrices with columns containing the
%          tangent,normal,and binormal vectors
% kap    - vector of curvature values
% tau    - vector of torsion values
% arclen - value of arc length approximated as 
%          the sum of chord values between 
%          successive points
%
% User m functions called: 
%          crvprp3d, cubrange
%----------------------------------------------

if nargin==0
  k=1; h=2; r0=2*pi; t=linspace(2*pi,8*pi,101);
end

% Evaluate R, R'(t), R''(t) and R'''(t) for 
% the spiral
t=t(:)'; s=sin(t); c=cos(t); kc=k*c; ks=k*s;
rk=r0+k*t; rks=rk.*s; rkc=rk.*c; n=length(t);
R=[rkc;rks;h*t]; R1=[kc-rks;ks+rkc;h*ones(1,n)];
R2=[-2*ks-rkc;2*kc-rks;zeros(1,n)];
R3=[-3*kc+rks;-3*ks-rkc;zeros(1,n)];

% Obtain geometrical properties 
[T,N,B,kap,tau]=crvprp3d(R1,R2,R3);
arclen=sum(sqrt(sum((R(:,2:n)-R(:,1:n-1)).^2)));

% Generate points on the osculating plane and
% the rectifying plane along the curve.
w=arclen/100; Rn=R+w*N;  Rb=R+w*B; 
X=[Rn(1,:);R(1,:);Rb(1,:)];
Y=[Rn(2,:);R(2,:);Rb(2,:)];
Z=[Rn(3,:);R(3,:);Rb(3,:)];

% Draw the surface
v=cubrange([X(:),Y(:),Z(:)]); hold off; clf; close;
surf(X,Y,Z); axis(v); xlabel('x axis');
ylabel('y axis'); zlabel('z axis');
title(['Spiral Showing Osculating and ', ...
       'Rectifying Planes']); grid on; drawnow; 
figure(gcf); 

%==============================================

function [T,N,B,kap,tau]=crvprp3d(R1,R2,R3)
%
% [T,N,B,kap,tau]=crvprp3d(R1,R2,R3)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the primary 
% differential properties of a three-dimensional 
% curve parameterized in the form R(t) where t 
% can be arc length or any other convenient 
% parameter such as time.
%
% R1  - the matrix with columns containing R'(t)
% R2  - the matrix with columns containing R''(t)
% R3  - the matrix with columns containing 
%       R'''(t).  This matrix is only needed 
%       when torsion is to be computed.
%
% T   - matrix with columns containing the 
%       unit tangent
% N   - matrix with columns containing the 
%       principal normal vector
% B   - matrix with columns containing the 
%       binormal
% kap - vector of curvature values
% tau - vector of torsion values. This equals 
%       [] when R3 is not given 
%
% User m functions called:  none
%----------------------------------------------

nr1=sqrt(dot(R1,R1)); T=R1./nr1(ones(3,1),:);
R12=cross(R1,R2); nr12=sqrt(dot(R12,R12));
B=R12./nr12(ones(3,1),:); N=cross(B,T); 
kap=nr12./nr1.^3;

% Compute the torsion only when R'''(t) is given
if nargin==3,   tau=dot(B,R3)./nr12; 
else, tau=[]; end

%==============================================

function [R,T,N,B,kappa]=crvprpsp(Rd,n)
%
% [R,T,N,B,kappa]=crvprpsp(Rd,n)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes spline interpolated 
% values for coordinates, base vectors and 
% curvature obtained by passing a spline curve 
% through data values given in Rd. 
%
% Rd    - a matrix containing x,y and z values 
%         in rows 1, 2 and 3.
% n     - the number of points at which 
%         properties are to be evaluated along 
%         the curve
%
% R     - a 3 by n matrix with columns 
%         containing coordinates of interpolated
%         points on the curve
% T,N,B - matrices of dimension 3 by n with 
%         columns containing components of the 
%         unit tangent, unit normal, and unit 
%         binormal vectors
% kappa - a vector of curvature values
%
% User m functions called: 
%         splined, crvprp3d
%----------------------------------------------

% Create a spline curve through the data points, 
% and evaluate the derivatives of R.
nd=size(Rd,2); td=0:nd-1; t=linspace(0,nd-1,n); 
ud=Rd(1,:)+i*Rd(2,:); u=spline(td,ud,t);
u1=splined(td,ud,t); u2=splined(td,ud,t,2);
ud3=Rd(3,:); z=spline(td,ud3,t);
z1=splined(td,ud3,t); z2=splined(td,ud3,t,2);
R=[real(u);imag(u);z]; R1=[real(u1);imag(u1);z1]; 
R2=[real(u2);imag(u2);z2];

% Get curve properties from crvprp3d
[T,N,B,kappa]=crvprp3d(R1,R2);

%==============================================

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

%=================================================

% function range=cubrange(xyz,ovrsiz)
% See Appendix B
