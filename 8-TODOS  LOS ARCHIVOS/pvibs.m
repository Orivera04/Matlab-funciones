function [t,x,y,m,v]= ...
          pvibs(y0,ei,arho,L,k,w,h,m0,j0,nx,nt) 
%
% [t,x,y,m,v]=pvibs ...
%             (y0,ei,arho,L,k,w,h,m0,j0,nx,nt) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the forced harmonic 
% response of a pile buried in an oscillating 
% elastic medium. The lower end of the pile is 
% free from shear and moment. The top of the 
% pile carries an attached body having general 
% mass and inertial properties. The elastic 
% foundation is given a horizontal oscillation 
% of the form 
%
%   yf=real(y0*exp(i*w*t))
%
% The resulting transverse forced response of 
% the pile is expressed as 
%
%   y(x,t)=real(f(x)*exp(i*w*t)) 
%
% where f(x) is a complex valued function. The 
% bending moment and shear force in the pile 
% are also computed.
%
% y0   - amplitude of the foundation oscillation
% ei   - product of moment of inertia and 
%        elastic modulus for the pile
% arho - mass per unit length of the pile
% L    - pile length
% k    - the elastic resistance constant for the 
%        foundation described as force per unit 
%        length per unit of transverse 
%        deflection
% w    - the circular frequency of the 
%        foundation oscillation which vibrates 
%        like real(y0*exp(i*w*t))
% h    - the vertical distance above the pile 
%        upper end to the gravity center of the 
%        attached body
% m0   - the mass of the attached body
% j0   - the mass moment of inertia of the 
%        attached body with respect to its 
%        gravity center
% nx   - the number of equidistant values along 
%        the pile at which the solution is 
%        computed
% nt   - the number of values of t values at 
%        which the solution is computed such 
%        that 0 <= w*t <= 2*pi
%
% t    - a vector of time values such that the 
%        pile moves through a full period of 
%        motion. This means 0 <= t <= 2*pi/w
% x    - a vector of x values with 0 <= x <= L 
% y    - the transverse deflection y(x,t) for 
%        the pile with t varying from row to 
%        row, and x varying from column to 
%        column             
% m,v  - matrices giving values bending moment 
%        and shear force
%
% User m functions called: none
%----------------------------------------------
 
% Default data for a steel pile 144 inches long
if nargin==0      
  y0=0.5; ei=64e7; arho=0.0118; L=144; k=800; 
  w=125.6637; h=9; m0=1.9051; j0=257.1876; 
  nx=42; nt=25;
end

w2=w^2; x=linspace(0,L,nx)'; 
t=linspace(0,2*pi/w,nt); 

% Evaluate characteristic roots and complex 
% exponentials
s=((arho*w2-k)/ei)^(1/4)*[1,i,-1,-i]; 
s2=s.^2; s3=s2.*s;
c0=y0*k/(k-w2*arho); esl=exp(s*L); 
esx=exp(x*s); eiwt=exp(i*w*t);

% Solve for coefficients to satisfy the 
% boundary conditions 
c=[s2; s3; esl.*(h*s3+s2-j0*w2/ei*s); ...
   esl.*(s3+m0*w2/ei*(1+h*s))]\ ...
   [0;0;0;-c0*m0*w2/ei];

% Compute the deflection, moment and shear
y=real((c0+esx*c)*eiwt)'; 
ype=real(s.*esl*c*eiwt)';
m=real(ei*s2(ones(nx,1),:).*esx*c*eiwt)';
v=real(ei*s3(ones(nx,1),:).*esx*c*eiwt)';
t=t'; x=x'; hold off; clf;

% Make surface plots showing the deflection, 
% moment, and shear over a complete period of 
% the motion 
surf(x,t*w,y); 
xlabel('x axis'); ylabel('t*w axis'); 
zlabel('transverse deflection');
title('Deflection Surface for a Vibrating Pile');
grid on; figure(gcf)
% print -deps pilesurf
disp('Press [Enter] to continue'), pause

surf(x,t*w,m); 
xlabel('x axis'); ylabel('t*w axis');
zlabel('bending moment');
title('Bending Moment in the Pile')
grid on; figure(gcf)
% print -deps pilemom;
disp('Press [Enter] to continue'), pause

surf(x,t*w,v); 
xlabel('x axis'); ylabel('t*w axis');
zlabel('shear force');
title('Shear Force in the Pile');
grid on; figure(gcf)
% print -deps pilesher
disp('Press [Enter] to see animation'), pause
 
% Draw an animation depicting the pile response 
% to the oscillation of the foundation
fu=.10/max(y(:)); p=[-0.70, 0.70, -.1, 1.3];
u=fu*y; upe=fu*L*ype; d=.15;
xm=[0,0,1,1,0,0]*d; 
ym=[0,-1,-1,1,1,0]*d; zm=xm+i*ym;
close;
for jj=1:4
  for j=1:nt
    z=exp(i*atan(upe(j)))*zm; 
    xx=real(z); yy=imag(z);
    ut=[u(j,:),u(j,nx)+yy]; xt=[x/L,1+xx];
    plot(ut,xt,'-'); axis(p); axis('square'); 
    title('Forced Vibration of a Pile');
    axis('off'); drawnow; figure(gcf);
  end
end
% print -deps pileanim
fprintf('\nAll Done\n');