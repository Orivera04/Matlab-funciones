function cablinea      
% Example: cablinea
% ~~~~~~~~~~~~~~~~~
% This program uses modal superposition to 
% compute the dynamic response of a cable 
% suspended at one end and free at the other. 
% The cable is given a uniform initial 
% velocity. Time history plots and animation 
% of the motion are provided.
%
% User m functions required: 
%    cablemk, udfrevib, canimate

% Initialize graphics
hold off; axis('normal'); close;

% Set physical parameters
n=30; gravty=1.; masses=ones(n,1)/n; 
lengths=ones(n,1)/n;

% Obtain mass and stiffness matrices
[m,k]=cablemk(masses,lengths,gravty);

% Assign initial conditions & time limit 
% for solution
dsp=zeros(n,1); vel=ones(n,1); 
tmin=0; tmax=10; ntim=30;

% Compute the solution by modal superposition
[t,u,modvc,natfrq]=...
  udfrevib(m,k,dsp,vel,tmin,tmax,ntim);

% Interpret results graphically
nt1=sum(t<=tmin); nt2=sum(t<=tmax);
u=[zeros(ntim,1),u]; 
y=cumsum(lengths); y=[0;y(:)];

% Plot deflection surface
disp(' '), disp('TRANSVERSE MOTION OF A CABLE')
surf(y,t,u); xlabel('y axis'); ylabel('time');
zlabel('transverse deflection');        
title('Surface Showing Cable Deflection'); 
colormap('default'), view([30,30]); figure(gcf);
disp(['Press [Enter] to see the cable ',...
      'position at two times'])
pause,  %print -deps surface

% Show deflection configuration at two times
% Use closer time increment than was used
% for the surface plots.
mtim=4*ntim; 
[tt,uu,modvc,natfrq]=...
  udfrevib(m,k,dsp,vel,tmin,tmax,mtim);
uu=[zeros(mtim,1),uu]; 
tp1=.1*tmax; tp2=.2*tmax; 
s1=num2str(tp1); s2=num2str(tp2);
np1=sum(tt<=tp1); np2=sum(tt<=tp2);
u1=uu(np1,:); u2=uu(np2,:);  
yp=flipud(y(:)); ym=max(yp);
plot(u1,yp,'-',u2,yp,'--');
ylabel('distance from bottom');
xlabel('transverse displacement'); 
title(['Cable Transverse Deflection ' ...
       'at t = ',s1,' and t = ',s2]);
legend('t = 1', 't = 2'); 

xm=.2*max([u1(:);u2(:)]);
ntxt=int2str(n); n2=1+fix(n/2);
str=strvcat(...
'The cable was initially vertical and was',...
'given a uniform transverse velocity.',...
['A ',ntxt,' link model was used.']); 
text(xm,.9*ym,str), figure(gcf); 
disp(['Press [Enter] to show the time ',...
'response at the middle and free end'])
pause, %print -deps twoposn

% Plot time history for the middle and the end
clf; plot(tt,uu(:,n2),'--',tt,uu(:,n+1),'-');
xlabel('dimensionless time');
ylabel('transverse displacement');
title(['Position versus Time for the ' ...
       'Cable Middle and End'])
legend('Midpoint','Lower end');
figure(gcf); 
disp('Press [Enter] for a motion trace')
pause, %print -deps 2timhist

% Plot animation of motion history
clf; canimate(y,u,t,0,.5*max(t),1);
%print -deps motntrac
disp('Press [Enter] to finish'), pause, close;

%=============================================

function [m,k]=cablemk(masses,lngths,gravty)
%
% [m,k]=cablemk(masses,lngths,gravty)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Form the mass and stiffness matrices for 
% the cable.
%
% masses     - vector of masses
% lngths     - vector of link lengths
% gravty     - gravity constant
% m,k        - mass and stiffness matrices
%
% User m functions called:  none.
%----------------------------------------------

m=diag(masses);
b=flipud(cumsum(flipud(masses(:))))* ...
  gravty./lngths;
n=length(masses); k=zeros(n,n); k(n,n)=b(n);
for i=1:n-1
  k(i,i)=b(i)+b(i+1); k(i,i+1)=-b(i+1);
  k(i+1,i)=k(i,i+1);
end

%=============================================

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

%=============================================

function canimate(y,u,t,tmin,tmax,norub)
%
% canimate(y,u,t,tmin,tmax,norub)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function draws an animated plot of 
% data values stored in array u. The 
% different columns of u correspond to position 
% values in vector y. The successive rows of u 
% correspond to different times. Parameter 
% tpause controls the speed of the animation.
%
% u         - matrix of values for which 
%             animated plots of u versus y 
%             are required
% y         - spatial positions for different 
%             columns of u
% t         - time vector at which positions 
%             are known
% tmin,tmax - time limits for graphing of the 
%             solution
% norub     - parameter which makes all 
%             position images remain on the 
%             screen. Only one image at a 
%             time shows if norub is left out. 
%             A new cable position appears each 
%             time the user presses any key
%
% User m functions called:  none.
%----------------------------------------------

% If norub is input, 
%   all images are left on the screen
if nargin < 6
  rubout = 1;
else
  rubout = 0;
end

% Determine window limits
umin=min(u(:)); umax=max(u(:)); udif=umax-umin;
uavg=.5*(umin+umax); 
ymin=min(y); ymax=max(y); ydif=ymax-ymin;
yavg=.5*(ymin+ymax); 
ywmin=yavg-.55*ydif; ywmax=yavg+.55*ydif;
uwmin=uavg-.55*udif; uwmax=uavg+.55*udif;
n1=sum(t<=tmin); n2=sum(t<=tmax); 
t=t(n1:n2); u=u(n1:n2,:);
u=fliplr (u); [ntime,nxpts]=size(u);

hold off; cla; ey=0; eu=0; axis('square');
axis([uwmin,uwmax,ywmin,ywmax]);
axis off; hold on;
title('Trace of Linearized Cable Motion');

% Plot successive positions
for j=1:ntime
  ut=u(j,:); plot(ut,y,'-'); 
  figure(gcf); pause(.5);
 
  % Erase image before next one appears
  if rubout & j < ntime, cla, end
end