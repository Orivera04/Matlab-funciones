function [t,x]= ...
        frud(m,k,f1,f2,w,x0,v0,wn,modvc,h,tmax)
%
% [t,x]=frud(m,k,f1,f2,w,x0,v0,wn,modvc,h,tmax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function employs modal superposition 
% to solve
%
%    m*x'' + k*x = f1*cos(w*t) + f2*sin(w*t)
%
% m,k    - mass and stiffness matrices
% f1,f2  - amplitude vectors for the forcing 
%          function
% w      - forcing frequency not matching any
%          natural frequency component in wn
% wn     - vector of natural frequency values
% x0,v0  - initial displacement and velocity 
%          vectors
% modvc  - matrix with modal vectors as its 
%          columns
% h,tmax - time step and maximum time for 
%          evaluation of the solution
% t      - column of times at which the 
%          solution is computed
% x      - solution matrix in which row j 
%          is the solution vector at 
%          time t(j)
%
% User m functions called:  none
%----------------------------------------------

t=0:h:tmax; nt=length(t); nx=length(x0); 
wn=wn(:); wnt=wn*t;

% Evaluate the particular solution.
x12=(k-(w*w)*m)\[f1,f2]; 
x1=x12(:,1); x2=x12(:,2);
xp=x1*cos(w*t)+x2*sin(w*t);

% Evaluate the homogeneous solution.
cof=modvc\[x0-x1,v0-w*x2]; 
c1=cof(:,1)'; c2=(cof(:,2)./wn)';
xh=(modvc.*c1(ones(1,nx),:))*cos(wnt)+...
   (modvc.*c2(ones(1,nx),:))*sin(wnt);

% Combine the particular and 
% homogeneous solutions.
t=t(:); x=(xp+xh)';