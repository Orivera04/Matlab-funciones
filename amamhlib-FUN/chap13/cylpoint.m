function r=cylpoint(w1,w2,r0,m,rdat,zdat)
% r=cylpoint(w1,w2,v,r0,m,rdat,zdat)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes the position of a
% point on the surface of a circular cylinder
% arbitrarily positioned in space. The argument
% list parameters have the following form,
% where rad means cylinder radius, and len 
% means cylinder length.
% b=2*rad+len;
% zdat=[[0,0]; [rad/b, 0];
%       [(rad+len)/b, len];[ 1, len]];
% rdat=zdat; rdat(2,2)=rad;
% rdat(3,2)=rad; rdat(4,2)=0; 

u=2*pi*sin(w1)^2; v=sin(w2)^2;
z=interp1(zdat(:,1),zdat(:,2),v); 
rho=interp1(rdat(:,1),rdat(:,2),v);
x=rho*cos(u); y=rho*sin(u); 
r=r0(:)+m*[x;y;z];