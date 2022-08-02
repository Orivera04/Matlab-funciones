function [x,y,z,rmin,dmin,d]=frusdist ...
         (rb,rt,h,nb,nt,ns,nc,re,vecs,r0)
% 
% [x,y,z,rmin,dmin,d]=
%      frusdist(rb,rt,h,nb,nt,ns,nc,re,vecs,r0)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines the point on the 
% surface of a conical frustum which is closest 
% to another point outside the surface. A grid 
% of points on the surface is formed along with 
% a matrix of distances from the remote point to 
% the surface points. The closest point is 
% determined by sorting elements of the 
% distance matrix. The surface and the line from 
% the nearest point to the closest surface point 
% are drawn. A surface is also plotted to depict 
% the distance matrix as a function of the axial 
% and circumferencial variables used to 
% construct the surface. For clarity the 
% negative of the distance matrix is plotted so 
% the peak on the surface identifies the point 
% having minimum distance.
% 
% rb,rt - the base and top radii of the frustum.
%         The base radius can be larger or 
%         smaller than the top radius.
% h     - the height of the frustum
% nb,nt - the number of plot increments taken 
%         on the base and on the top
% ns,nc - the number of increments taken on 
%         the side and around the circumference.
% re    - a vector to the center of the base
% vecs  - a matrix having two columns which 
%         define the orientation of the conical 
%         frustum. vecs(:,1) gives the direction 
%         of the axis of the frustum. The cross 
%         product of vecs(:,1) and vecs(:,2) 
%         gives the direction of the third base 
%         vector defining a triad of local base
%         vectors centered at re on the base. 
%         (See function frustum for more detail.)
% r0    - coordinate vector of the remote point 
%         for which the closest point on the 
%         frustum is sought
%
% x,y,z - matrices of coordinate points on the 
%         surface of the frustum
% rmin  - the vector for the point closest to 
%         the remote point r0 
% dmin  - the shortest distance  
% d     - the matrix containing distances from 
%         the outside point to surface points. 
%
% User m functions called: 
%    frustum, cubrange, surfesy

% Default data case
if nargin==0
  rb=1; rt=2; Rb=2*[1,1,1]; Rt=2*[3,3,3]; 
  va=Rt-Rb; h=norm(va); re=Rb; 
  vecs=[va(:),[1;-1;0]]; r0=[4,0,8];
  nb=10; nt=10; ns=20; nc=35;
end

% Call function frustum to generate points on 
% the surface
r=[rb;rt]; n=[nb;ns;nt;nc]; 
[x,y,z]=frustum(r,h,n,vecs);
x=x+re(1); y=y+re(2); z=z+re(3);

% Form the matrix containing distances from 
% the outside point to surface points. 
d=sqrt((x-r0(1)).^2+(y-r0(2)).^2+(z-r0(3)).^2); 

% Compute the minimum and the related 
% surface point
[dmin,J]=min(min(d)); [dmin,I]=min(min(d'));
rmin=[x(I,J);y(I,J);z(I,J)]; R=[rmin,r0(:)];

% Generate points to plot the line from the 
% outside point to the nearest surface point. 
R=[linspace(rmin(1),r0(1),50);
   linspace(rmin(2),r0(2),50);
   linspace(rmin(3),r0(3),50)];

% Create a window range for undistorted 
% plotting
v=cubrange([[x(:),y(:),z(:)];r0(:)']);

% Draw the line and then the conical frustum
hold off, close, colormap('default');
[M,N]=size(R);
plot3(R(1,:),R(2,:),R(3,:),'-', ...
      R(1,N),R(2,N),R(3,N),'o');
hold on; 
surfesy(x,y,z,'x axis','y axis','z-axis',...
        'Closest Point on a Surface',v);
axis(v); figure(gcf); hold off;
print -deps closept
input('Press [Enter] to continue','s'); 

% Draw a surface showing -d on which the 
% highest point identifies the minimum distance 
% point
[naxial,mcircum]=size(d); N=(1:naxial)/naxial;
M=(1:mcircum)/mcircum; surf(M,N,-d); 
title('Inverted Minimum Distance Surface');
xlabel('circumferential coordinate');
ylabel('radial coordinate');
zlabel('negative of d matrix'); figure(gcf);
print -deps minsurf

%=============================================

function [x,y,z]=frustum(r,h,n,vecs)
%
% [x,y,z]=frustum(r,h,n,vecs)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function creates points defining a 
% frustum of a cone having its axis in 
% the z direction oriented relative to different 
% axes depending on parameters specified in 
% argument vecs.
%
% r    - a vector containing [rb,rt] where rb 
%        is the base radius and rt is the top 
%        radius. If only one number is input 
%        then rt is set equal to rb.
% h    - height of the frustum
% n    - a vector defining the number of radial 
%        increments taken on the base, the 
%        side, the end and the circumference. 
%        n has the form [nb,ns,nt,nc]. 
%        Using [1,1,1,4] generates a cube.
% vecs - a matrix having three rows and either 
%        one or two columns which determines 
%        the axis orientation of the frustum. 
%        When vecs is not input the surface has 
%        its base on the the xy plane and its
%        longitudinal axis along the z 
%        direction. If vecs is present, the 
%        longitudinal axis is in the direction 
%        of vecs(:,1) and the shifted y axis 
%        is in the direction of vecs(:,1) 
%        crossed into vecs(:,2).  
% 
% x,y,z- matrices of coordinate points on the
%        surface of the frustum
%
% User m functions called:  none
%----------------------------------------------

if nargin<4, vecs=[]; end

% The default data creates a cube of unit 
% side length
if nargin==0 
  r=1/sqrt(2)*[1,1]; h=1; n=[1,1,1,4]; 
end 

rb=r(1); nb=n(1); ns=n(2); rt=rb;
if length(r)==1, rt=rb; else rt=r(2); end
if length(n)>2, nt=n(3); else, nt=nb; end
if length(n)>3, nc=n(4); else, nc=36; end

% Generate radius values for rotation about 
% the z axis
R=[linspace(0,rb*(nb-1)/nb,nb), ...
   linspace(rb,rt,ns+1),...
   linspace(rt*(nt-1)/nt,0,nt)]';
z=[zeros(1,nb),linspace(0,h,ns+1),h*ones(1,nt)]';
z=z(:,ones(1,nc+1));

% Make a surface of revolution by rotation 
% about the z axis
th=linspace(pi/nc,pi/nc+2*pi,nc+1);
x=R*cos(th); y=R*sin(th);
if nargin<4 | isempty(vecs), return, end

% If vecs is present shift the axes of the 
% frustum appropriately.
[N,M]=size(x); e3=vecs(:,1); e3=e3/norm(e3); 
if size(vecs,2)==1
  u=null(e3'); u=[u(:,1),cross(e3,u(:,1)),e3];
else
  e2=cross(e3,vecs(:,2)); e2=e2/norm(e2); 
  u=[cross(e2,e3),e2,e3];
end
w=[x(:),y(:),z(:)]*u'; x=reshape(w(:,1),N,M);
y=reshape(w(:,2),N,M); z=reshape(w(:,3),N,M);

%=============================================

function surfesy(x,y,z,xlab,ylab,zlab,titl,v)
%
% surfesy(x,y,z,xlab,ylab,zlab,titl,v)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function provides an easy input 
% interface to function surf.
%
% x,y,z          - data for surface plotting
% xlab,ylab,zlab - labels for the coordinate 
%                  axes
% titl           - a title for the plot
% v              - a vector to set the axis 
%                  range. If no value is input, 
%                  a range is found to make an 
%                  undistorted plot. If a 
%                  single number is input, the 
%                  default scaling is used 
%
% User m functions called:  cubrange
%----------------------------------------------

if nargin<8, v=cubrange(x,y,z); end 
if nargin<7, titl=[]; end
if nargin<6, xlab=''; ylab=''; zlab=''; end
surf(x,y,z); xlabel(xlab); ylabel(ylab);
zlabel(zlab); title(titl);
if length(v)>2, axis(v); end
grid on; figure(gcf);