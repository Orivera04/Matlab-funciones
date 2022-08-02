function [res1,res2] = newmark_scheme(func,X,dx,dt,c,a,b,Tfinal,n,beta,theta)
% Solution of the wave equation
% 
%    u_tt - c^2*u_xx = 0
%
% x \in I=[a,b]  and  t \in [0,T] with the 
% initial data  u(x,0)  = u_0(x) 
%           and u'(x,0) = v_0(x)
% and the boundary conditions
%   u(a,t) = 0 and u(b,t) = 0 
% with the  Newmark Scheme.
%
% This method is presented for example in 
% Quarteroni/Sacco/Saleri: Numerische Mathematik 2

% Author     : Stefan Hüeber
% Date       : Februar 3, 2003
% Institution: University of Stuttgart,
%              Institut for Applied Analysis and Numerical Mathematics,
%              Numerical Mathematics for super computers  
% Version    : 1.0

% time derivative
v0=inline('0*x');

% Newmark-Scheme
%beta = 0.0025;%0.25;
%theta = 0.5;

I = [a b]; %Interval
T = 0:dt:Tfinal;
R = (c*dt/dx)^2;
NX = n;
NT = length(T);

% Initial conditions
SOL = zeros(2*(NX+1),2);
SOLPLOT = zeros(NX+1,NT+1);

SOLtemp = feval(func,X);
for j = 2:NX
    SOL(j,1) = SOLtemp(j);
end
SOLPLOT(:,1) = SOL(1:NX+1,1);

% Finite Difference-Scheme: Newmark-Scheme
M = spdiags([ones(NX,1),-2*ones(NX,1),ones(NX,1)],[-1,0,1],NX-1,NX-1);
MAT = speye(NX-1) - R*beta*M;

for n = 1:NT
	% value of the function
    rhs = (speye(NX-1) + R*(0.5-beta)*M)*SOL(2:NX,1) + dt*SOL(NX+3:2*NX+1,1);
	SOL(2:NX,2) = MAT\rhs;
	SOL(NX+3:2*NX+1,2) = (R/dt)*(theta*M*SOL(2:NX,2) + (1-theta)*M*SOL(2:NX,1)) + ...
				                           SOL(NX+3:2*NX+1,1);
	SOL(:,1) = SOL(:,2);
	SOLPLOT(:,n+1) = SOL(1:NX+1,1);
end
res1 = SOLPLOT;
res2 = T;