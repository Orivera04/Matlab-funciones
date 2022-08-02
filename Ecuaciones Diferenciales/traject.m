function [y,x,t]=traject ...
        (angle,vinit,gravty,cdrag,xfinl,noplot)
% [y,x,t]=traject ...
%       (angle,vinit,gravty,cdrag,xfinl,noplot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function integrates the dynamical 
% equations for a projectile subjected to
% gravity loading and atmospheric drag
% proportional to the square of the velocity.
%
% angle  - initial inclination of the 
%          projectile in degrees
% vinit  - initial velocity of the projectile 
%          (muzzle velocity)
% gravty - the gravitational constant
% cdrag  - drag coefficient specifying the drag 
%          force per unit mass which equals 
%          cdrag*velocity^2.
% xfinl  - the projectile is fired toward the 
%          right from x=0.  xfinl is the 
%          largest x value for which the 
%          solution is computed. The initial 
%          velocity must be large enough that 
%          atmospheric damping does not reduce 
%          the horizontal velocity to zero 
%          before xfinl is reached.  Otherwise 
%          an error termination will occur.
% noplot - plotting of the trajectory is 
%          omitted when this parameter is 
%          given an input value
%
% y,x,t  - the y, x and time vectors produced 
%          by integrating the equations of 
%          motion
%
% Global variables:
%
% grav,  - two constants replicating gravty and 
% dragc    cdrag, for use in function projcteq
% vtol   - equal to vinit/1e6, used in projcteq
%          to check whether the horizontal 
%          velocity has been reduced to zero   
%
% User m functions called: projcteq

global grav dragc vtol 

% Default data case generated when input is null
if nargin ==0 
  angle=45; vinit=600; gravty=32.2; 
  cdrag=0.002; xfinl=1000;
end; 

% Assign global variables and evaluate 
% initial velocity
grav=gravty; dragc=cdrag; ang=pi/180*angle; 
vtol=vinit/1e6; 
z0=[vinit*cos(ang); vinit*sin(ang); 0; 0];

% Integrate the equations of motion defined 
% in function projcteq
deoptn=odeset('RelTol',1e-6);
[x,z]=ode45(@projcteq,[0,xfinl],z0,deoptn);

y=z(:,3); t=z(:,4); n=length(x); 
xf=x(n); yf=y(n);

% Plot the trajectory curve
if nargin < 6
  close; plot(x,y,'-',xf,yf,'o');
  xlabel('x axis'); ylabel('y axis');
  title(['Projectile Trajectory for ', ...
         'Velocity Squared Drag']);
  axis('equal'); grid on; figure(gcf);
  % print -deps trajplot
end

%=============================================

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
