function zp=projcteq(x,z)
%
% zp=projcteq(x,z)
% ~~~~~~~~~~~~~~~~
%
% This function defines the equation of motion 
% for a projectile loaded by gravity and 
% atmospheric drag proportional to the square 
% of the velocity.
%
% x     -  the horizontal spatial variable
% z     -  a vector containing [vx; vy; y; t];
%
% zp    -  the derivative dz/dx which equals
%          [vx'(x); vy'(x); y'(x); t'(x)];
%
% Global variables:
%
% grav  -  the gravity constant 
% dragc -  the drag coefficient divided by 
%          gravity 
% vtol  -  a global variable used to check 
%          whether vx is zero  
%
% User m functions called:  none
%----------------------------------------------

global grav dragc vtol
vx=z(1); vy=z(2); v=sqrt(vx^2+vy^2);

% Check to see whether drag reduced the
% horizontal velocity to zero before the
% xfinl was reached.
if abs(vx) < vtol
  disp(' ');
  disp('*************************************');
  disp('ERROR in function projcteq. The ');
  disp('  initial velocity of the projectile');
  disp('  was not large enough for xfinal to');
  disp('  be reached.');
  disp('EXECUTION IS TERMINATED.');
  disp('*************************************');
  disp(' '),error(' ');
end
zp=[-dragc*v; -(grav+dragc*v*vy)/vx; ...
    vy/vx; 1/vx];