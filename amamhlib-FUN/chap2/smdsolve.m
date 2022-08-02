function [x,v]=smdsolve(m,c,k,f1,f2,w,x0,v0,t)
%
% [x,v]=smdsolve(m,c,k,f1,f2,w,x0,v0,t)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function solves the differential equation
% m*x''(t)+c*x'(t)+k*x(t)=f1*cos(w*t)+f2*sin(w*t)
% with x(0)=x0 and x'(0)=v0
%
% m,c,k  - mass, damping and stiffness coefficients
% f1,f2  - magnitudes of cosine and sine terms in
%          the forcing function
% w      - frequency of the forcing function
% t      - vector of times to evaluate the solution
% x,v    - computed position and velocity vectors

ccrit=2*sqrt(m*k); wn=sqrt(k/m);

% If the system is undamped and resonance will 
% occur, add a little damping
if c==0 & w==wn; c=ccrit/1e6; end;

% If damping is critical, modify the damping
% very slightly to avoid repeated roots
if c==ccrit; c=c*(1+1e-6); end 

% Forced response solution
a=(f1-i*f2)/(k-m*w^2+i*c*w);
X0=real(a); V0=real(i*w*a);
X=real(a*exp(i*w*t)); V=real(i*w*a*exp(i*w*t));

% Homogeneous solution
r=sqrt(c^2-4*m*k);  
s1=(-c+r)/(2*m); s2=(-c-r)/(2*m); 
p=[1,1;s1,s2]\[x0-X0;v0-V0];

% Total solution satisfying the initial conditions 
x=X+real(p(1)*exp(s1*t)+p(2)*exp(s2*t));
v=V+real(p(1)*s1*exp(s1*t)+p(2)*s2*exp(s2*t));