function zdot=topde(t,z,uz,c1,c2)
%
% zdot=topde(t,z,uz,c1,c2)
% ~~~~~~~~~~~~~~~
%
% This function defines the equation of motion
% for a symmetrical top. The vector z equals 
% [r(:);v(:)] which contains the Cartesian 
% components of the gravity center radius and 
% its velocity.
%
% t    - the time variable
% z    - the vector [x; y; z; vx; vy; vz]
% uz   - the vector [0;0;1]
% c1   - wt*len^2/jtrans
% c2   - omegax*jaxial/jtrans 
%
% zdot - the time derivative of z
%
% User m functions called:  none
%----------------------------------------------

z=z(:); r=z(1:3); len=norm(r); ur=r/len;

% Make certain the input velocity is 
% perpendicular to r
v=z(4:6); v=v-(ur'*v)*ur;
vdot=-c1*(uz-ur*ur(3))+c2*cross(ur,v)- ...
     ((v'*v)/len)*ur;
zdot=[v;vdot];