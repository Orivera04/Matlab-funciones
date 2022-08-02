function [v,rc,vrr,x,y,z,t]=twistrope(...
                          a,b,m,x0,y0,z0,nt,np)
%                        
% [v,rc,vrr,x,y,z,t]=twistrope(...
%                  a,b,m,x0,y0,z0,nt,nm)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Geometrical properties of a twisted rope.
% This example takes 1.3 seconds to run
if nargin<8, np=321; end; if nargin<7, nt=161; end
if nargin==0
   a=6; b=1; m=6; x0=1; y0=2; z0=3; 
end
t=linspace(0,2*pi,nt); p=linspace(0,3*pi,np)';
t=repmat(t,np,1); p=repmat(p,1,nt);

% Surface equation for the twisted rope

xi=b*cos(t).*abs(cos(t));
eta=b*sin(t).*abs(cos(t));
rho=a+xi.*cos(m*p)+eta.*sin(m*p);
x=rho.*cos(p)+x0; y=rho.*sin(p)+y0; 
z=-xi.*sin(m*p)+eta.*cos(m*p)+p+z0;

[v,rc,vrr]=srfv(x,y,z);