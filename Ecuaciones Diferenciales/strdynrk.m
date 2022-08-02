function [t,x,v]=strdynrk(t,x0,v0,m,c,k,functim)
% [t,x,v]=strdynrk(t,x0,v0,m,c,k,functim)
% This function uses ode45 to solve the matrix
% differential equation: M*X"+C*X'+K*X=F(t)
% t       - vector of solution times
% x0,v0   - initial position and velocity vectors
% m,c,k   - mass, damping and stiffness matrices
% functim - character name for the driving force
% x,v     - arrays containing solution values for 
%           position and velocity
%
% A typical call to strdynrk function is:
% m=eye(3,3); k=[2,-1,0;-1,2,-1;0,-1,2];
% c=.05*k; x0=zeros(3,1); v0=zeros(3,1);
% t=linspace(0,10,101);
% [t,x,v]=strdynrk(t,x0,v0,m,c,k,'func');

global Mi C K F n n1 n2
Mi=inv(m); C=c; K=k; F=functim;
n=size(m,1); n1=1:n; n2=n+1:2*n;
[t,z]=ode45(@sde,t,[x0(:);v0(:)]);
x=z(:,n1); v=z(:,n2);
 
%================================

function zp=sde(t,z)
% zp=sde(t,z)
global Mi C K F n n1 n2
zp=[z(n2); Mi*(feval(F,t)-C*z(n2)-K*z(n1))];

%================================

function f=func(t)
% f=func(t)
% This is an example forcing function for  
% function strdynrk in the case of three
% degrees of freedom. 
f=[-1;0;2]*sin(1.413*t);