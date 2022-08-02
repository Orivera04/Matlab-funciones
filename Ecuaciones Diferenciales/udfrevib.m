function [t,u,mdvc,natfrq]=...
               udfrevib(m,k,u0,v0,tmin,tmax,nt)
%
% [t,u,mdvc,natfrq]= ...
%              udfrevib(m,k,u0,v0,tmin,tmax,nt)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes undamped natural 
% frequencies, modal vectors, and time response 
% by modal superposition.  The matrix 
% differential equation and initial conditions 
% are  
%
%    m u'' + k u = 0,  u(0) = u0, u'(0) = v0
%
% m,k       - mass and stiffness matrices
% u0,v0     - initial position and velocity 
%             vectors
% tmin,tmax - time limits for solution 
%             evaluation
% nt        - number of times for solution
% t         - vector of solution times
% u         - matrix with row j giving the 
%             system response at time t(j)
% mdvc      - matrix with columns which are 
%             modal vectors
% natfrq    - vector of natural frequencies
%
% User m functions called:  none.
%----------------------------------------------

% Call function eig to compute modal vectors 
% and frequencies
[mdvc,w]=eig(m\k); 
[w,id]=sort(diag(w)); w=sqrt(w);

% Arrange frequencies in ascending order
mdvc=mdvc(:,id); z=mdvc\[u0(:),v0(:)];

% Generate vector of equidistant times
t=linspace(tmin,tmax,nt); 

% Evaluate the displacement as a 
% function of time
u=(mdvc*diag(z(:,1)))*cos(w*t)+...
  (mdvc*diag(z(:,2)./w))*sin(w*t);
t=t(:); u=u'; natfrq=w;