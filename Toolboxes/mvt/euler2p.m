function [epsilon, beta] = euler2p(ptp)
% EULER2P Converts an Euler rotation to a principal rotation.
%    [BETA, EPSILON] = EULER2P(PTP) converts an euler rotation 
%    PTP = [PHI THETA PSI] about the xyz-axis to a principal 
%    rotation BETA about the vector EPSILON.
% 
%    Uses euler2q.m to convert from euler to quaternion,
%    requires GNCtoolbox by T. I. Fossen, 2001.
%
% Author:   Andreas Lund Danielsen
% Date:     27th October 2003
% Revisions: 

% from euler to quaternions
quat = euler2q(ptp(1), ptp(2), ptp(3));

% return vector epsilon and angle beta
epsilon = quat(2:4)';
beta = 2*acos(quat(1));


%%%%%%%% LOCAL FUNCTIONS %%%%%%%%%
% both functions are from the 
% GNCtoolbox, T. I. Fossen (2002)

function q = euler2q(phi,theta,psi)
% q = EULER2Q(phi,theta,psi) computes the unit quaternions q = [eta eps1 eps2 eps3]
% from Euler angles phi, theta and psi
%
% Author:   Thor I. Fossen
% Date:     8th June 2000
% Revisions: 6 October 2001, T I. Fossen - eta as first element in q  

R   = Rzyx(phi,theta,psi);
R(4,4) = trace(R);
[Rmax,i] = max( [R(1,1) R(2,2) R(3,3) R(4,4)] );
p_i= sqrt(1+2*R(i,i)-R(4,4));
if i==1,
   p1 = p_i;
   p2 = (R(2,1)+R(1,2))/p_i;
   p3 = (R(1,3)+R(3,1))/p_i;
   p4 = (R(3,2)-R(2,3))/p_i;
elseif i==2,
   p1 = (R(2,1)+R(1,2))/p_i;
   p2 = p_i;
   p3 = (R(3,2)+R(2,3))/p_i;
   p4 = (R(1,3)-R(3,1))/p_i;
elseif i==3,
   p1 = (R(1,3)+R(3,1))/p_i;
   p2 = (R(3,2)+R(2,3))/p_i;   
   p3 = p_i;
   p4 = (R(2,1)-R(1,2))/p_i;   
else
   p1 = (R(3,2)-R(2,3))/p_i;
   p2 = (R(1,3)-R(3,1))/p_i;
   p3 = (R(2,1)-R(1,2))/p_i;   
   p4 = p_i;
end

q = 0.5*[p4 p1 p2 p3]';
q = q/(q'*q);


function R = Rzyx(phi,theta,psi)
% R = Rzyx(phi,theta,psi) computes the Euler angle
% rotation matrix R in SO(3) using the zyx convention
%
% Author:   Thor I. Fossen
% Date:     14th June 2001
% Revisions: 

cphi = cos(phi);
sphi = sin(phi);
cth  = cos(theta);
sth  = sin(theta);
cpsi = cos(psi);
spsi = sin(psi);
 
R = [...
   cpsi*cth  -spsi*cphi+cpsi*sth*sphi  spsi*sphi+cpsi*cphi*sth
   spsi*cth  cpsi*cphi+sphi*sth*spsi   -cpsi*sphi+sth*spsi*cphi
   -sth      cth*sphi                  cth*cphi ];