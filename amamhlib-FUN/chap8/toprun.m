function toprun      
% Example: toprun 
% ~~~~~~~~~~~~~~~
%
% Example that analyzes the response of a
% spinning conical top.
%
% User m functions required:
%    topde, cubrange, inputv

disp(' ');
disp(['*** Dynamics of a Homogeneous ', ...
      'Conical Top ***']); disp(' ');
disp(['Input the gravity constant and the ', ...
      'body weight (try 32.2,5)']);
[grav,wt]=inputv('? '); 
mass=wt/grav; tmp=zeros(3,1); 
disp(' '); 
disp(['Input the height and base radius ', ...
      '(try 1,.5)']);
[ht,rb]=inputv('? '); len=.75*ht;
jtrans=3*mass/20*(rb*rb+4*ht*ht); 
jaxial=3*mass*rb*rb/10;
disp(' ');
disp(['Input a vector along the initial ', ...
      'axis direction (try 0,1,0)']);
[tmp(1),tmp(2),tmp(3)]=inputv('? '); 
e3=tmp(:)/norm(tmp); r0=len*e3;
disp(' ');
disp(['Input the initial angular velocity ', ...
      '(try 0,10,2)']);
[tmp(1),tmp(2),tmp(3)]=inputv('? '); omega0=tmp; 
omegax=e3'*omega0(:); rdot0=cross(omega0,r0); 
z0=[r0(:);rdot0(:)]; uz=[0;0;1]; 
c1=wt*len^2/jtrans; c2=omegax*jaxial/jtrans;
disp(' '); 
disp(['Input tfinal,and the integration ', ...
      'tolerance (try 4.2, 1e-8)']);
[tfinl,tol]=inputv('? '); disp(' ');
fprintf( ...
  'Please wait for solution of equations.\n');

% Integrate the equations of motion
odeoptn=odeset('RelTol',tol);
[tout,zout]=ode45(@topde,[0,tfinl],z0,...
                  odeoptn,uz,c1,c2);
t=tout; x=zout(:,1); y=zout(:,2); z=zout(:,3);
vx=zout(:,4); vy=zout(:,5); vz=zout(:,6); 

% Compute total energy and angular momentum 
c3=jtrans/(len*len); taxial=jaxial/2*omegax^2;
r=zout(:,1:3)'; v=zout(:,4:6)';
etotal=(wt*r(3,:)+taxial+c3/2*sum(v.*v))'; 
h=(jaxial*omegax/len*r+c3*cross(r,v))';

% Plot the path of the gravity center
close; axis('equal'); 
axis(cubrange([x(:),y(:),z(:)])); plot3(x,y,z);
title('Path of the Top Gravity Center');
xlabel('x axis'); ylabel('y axis'); 
zlabel('z axis'); grid on; figure(gcf); 
disp(' '); disp(...
'Press [Enter] to plot error measures'), pause 
% print -deps toppath 
n=2:length(t);

% Compute energy and angular momentum error 
% quantities and plot results
et=etotal(1); enrger=abs(100*(etotal(n)-et)/et);
hzs=abs(h(1,3)); 
angmzer=abs(100*(h(n,3)-hzs)/hzs);
vec=[enrger(:);angmzer(:)]; 
minv=min(vec); maxv=max(vec);

clf; 
semilogy(t(n),enrger,'-r',t(n),angmzer,':m');
axis('normal'); xlabel('time'); 
ylabel('percent variation');
title(['Percent Variation in Total Energy ', ...
       'and z-axis Angular Momentum']);
legend(' Energy      (Upper Curve)', ...
       ' Ang. Mom. (Bottom Curve)',4);
figure(gcf), pause
% print -deps topvar

disp(' '), disp('All Done')

%=============================================

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

%=============================================

% function varargout=inputv(prompt)
% See Appendix B

% =============================================

% function range=cubrange(xyz,ovrsiz)
% See Appendix B