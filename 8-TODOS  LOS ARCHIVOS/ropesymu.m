function [vn,rcn,irrn,vs,rcs,irrs,times,nt,np]=...
                      ropesymu(A,B,M,X0,Y0,Z0,nt,np)
%                  
% [vn,rcn,irrn,vs,rcs,irrs,times,nt,np]=ropesymu(...
%                                A,B,M,X0,Y0,Z0,nt,np)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This program computes geometrical properties of a
% twisted rope having a cross section which is two
% circles of diameter B touching tangentially. The 
% tangency point is at distance A from the rotation 
% axis z. As the area is rotated, it is also twisted
% in a helical fashion. For a complete revolution 
% about the z axis, the area is twisted through m
% turns. The resulting surface resembles a rope 
% composed of two strands. Two results are obtained
% 1) by a numerical method where the surface is
% modeled with triangular surface patches and 
% 2) by symbolic math. See functions twistrope and
% twistprop for descriptions of the problem parameters.
% Numerical results and computation times for the two
% methods are compared, and the related surface 
% geometry is plotted
%
% User functions called: twistrope twistprop ropedraw
%----------------------------------------------------

if nargin==0 % Default data case
  A=3; B=1; m=6; np=201; nt=25; 
  X0=0; Y0=0; Z0=-3*pi/2; M=6;
end

disp(' ')
disp('   COMPARISON OF NUMERICAL AND SYMBOLIC')
disp('GEOMETRICAL PROPERTIES FOR A TWISTED ROPE')

% Run the first time to get a crude grid for plotting
[vn,rcn,irrn,x,y,z,c]=twistrope(A,B,M,X0,Y0,Z0,nt,np);

% Numerical solution using a dense point grid to get
% close comparison with exact results. Calculations
% are run repeatedly for accurate timing.
Nt=4*nt; Np=4*np; n=50; tic;
for i=1:n
 [vn,rcn,irrn]=twistrope(A,B,M,X0,Y0,Z0,Nt,Np);
end
timn=toc/n; 

% Perform the symbolic analysis. This takes a long
% time.
tic; 
[v,rc,vrr,vs,rcs,irrs]=twistprop(A,B,M,X0,Y0,Z0);
tims=toc; times=[timn,tims];

disp(' ')
disp('FOR THE TRIANGULAR SURFACE PATCH MODEL')
disp(['Volume = ',num2str(vn)])
disp(['Rg = [',num2str(rcn(:)'),']'])
disp('Irr = '), disp(irrn)
disp(['Computation Time = ',num2str(timn),' Secs.'])

% Print numerical comparisons of results
disp(' ')
disp('FOR THE SYMBOLIC MODEL')
disp(['Volume = ',num2str(vs)])
disp(['Rg = [',num2str(rcs(:)'),']'])
disp('Irr = '), disp(irrs)
disp(['Computation Time = ',num2str(tims),' Secs.'])

disp(' ')
disp(' NUMERICAL APPROXIMATION ERROR USING TRIANGULAR')
disp('SURFACE PATCHES. THE ERROR VALUES ARE DEFINED AS')
disp('        NORM(APPROX.-EXACT)/NORM(EXACT)')
evol=abs(vn-vs)/vs; erad=norm(rcs(:)-rcn(:))/norm(rcs);
einert=norm(irrn-irrs)/norm(irrs);
disp(['Volume Error = ',num2str(evol)])
disp(['Centroidal Radius Error = ',num2str(erad)])
disp(['Inertia Tensor Error = ',num2str(einert)])

disp(' ')
disp('COMPARISON OF SOLUTION TIMES')
disp(['(Symbolic Time)/(Numerical Time) = ',...
      num2str(tims/timn)])
disp(' ')
            
% Draw the surface using a crude grid to avoid
% crowded grid lines
ropedraw(A,B,np,nt,M,X0,Y0,Z0);

%===========================================

function [x,y,z,t]=ropedraw(a,b,np,nt,m,x0,y0,z0)
%
% [x,y,z,t]=ropedraw(a,b,np,mp,m,x0,y0,z0)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function draws the twisted rope.
if nargin==0
  a=3; b=1; np=200; nt=25; m=6;
  x0=0; y0=0; z0=-3*pi/2;
end

% Draw the surface 
t=linspace(0,2*pi,nt); p=linspace(0,3*pi,np)';
t=repmat(t,np,1); p=repmat(p,1,nt);
xi=b*cos(t).*abs(cos(t)); eta=b*sin(t).*abs(cos(t));
rho=a+xi.*cos(m*p)+eta.*sin(m*p);
x=rho.*cos(p)+x0; y=rho.*sin(p)+y0; 
z=-xi.*sin(m*p)+eta.*cos(m*p)+p+z0;
close; surf(x,y,z,t), title('TWISTED ROPE')
xlabel('x axis'), ylabel('y axis'), zlabel('z axis')
colormap('prism(4)'), axis equal, hold on

% Fill the ends
fill3(x(1,:),y(1,:),z(1,:),'w')
fill3(x(end,:),y(end,:),z(end,:),'w') 
view([-40,10]), hold off, shg

%===========================================

function [v,rc,vrr,V,Rc,Irr]=twistprop(A,B,M,X0,Y0,Z0)
%
% [v,rc,vrr,V,Rc,Irr]=twistprop(A,B,M,X0,Y0,Z0)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes geometrical properties of
% a twisted rope. Exact results are obtained using
% symbolic math to evaluate three surface integrals 
% for the volume, centroidal radius, and inertia 
% tensor. The symbolic calculations take about five 
% minutes to run.
%
% A,B,N    - parameters defining the twisted rope
% X0,Y0,Z0 - center coordinates for the centroid of
%            the twisted rope
% v,rc     - symbolic formulas for the volume and
%            centroid radius
% vrr      - symbolic formula for integral of
%            r*r'*d(vol)
% V,Rc     - numerical values for volume and 
%            centroid radius
% Irr      - numerical value for the inertia tensor

if nargin==0
   A=6; B=1; M=6; X0=1; Y0=2; Z0=3;
end

syms a b m t p xi eta rho x y z r rt rp real
syms x0 y0 z0 real
syms n dv dv1 v vr1 vr rg vrr1 vrr real
a=sym(A); b=sym(B); Pi=sym('pi');
x0=sym(X0); y0=sym(Y0); z0=sym(Z0);

% Surface equation for the twisted rope
xi=b*cos(t)*abs(cos(t));
eta=b*sin(t)*abs(cos(t));
rho=a+xi*cos(m*p)+eta*sin(m*p);
x=rho*cos(p)+x0; y=rho*sin(p)+y0; 
z=-xi*sin(m*p)+eta*cos(m*p)+p+z0;
Pi=sym('pi'); 

% Tangent vectors 
r=[x;y;z]; rt=diff(r,t); rp=diff(r,p);

% Integrate to get the volume
dv=det([r,rp,rt]); dv1=int(dv,t,0,2*Pi); 
v=simple(int(dv1,p,0,3*Pi)/3);

% First moment of volume
vr1=int(r*dv,t,0,2*Pi); 
vr=simple(int(vr1,p,0,3*Pi)/4);

% Radius to the centroid
rc=simple(vr/v);

% Integral of r*r'*d(vol)
vrr1=int(r*r'*dv,t,0,2*Pi);
vrr=simple(int(vrr1,p,0,3*Pi)/5);

% Obtain numerical values
V=double(subs(v,{a,b,m,x0,y0,z0},...
   {A,B,M,X0,Y0,Z0}));
Rc=double(subs(rc,{a,b,m,x0,y0,z0},...
   {A,B,M,X0,Y0,Z0}));
Irr=double(subs(vrr,{a,b,m,x0,y0,z0},...
   {A,B,M,X0,Y0,Z0}));

% Rigid body inertia tensor for a 
% body of unit mass density     
Irr=eye(3,3)*sum(diag(Irr))-Irr;

%===========================================

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

%===========================================

function [v,rc,vrr]=srfv(x,y,z)
%
% [v,rc,vrr]=srfv(x,y,z)
% ~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes the volume, centroidal
% coordinates, and inertial tensor for a volume
% covered by surface coordinates contained in
% arrays x,y,z
%
% x,y,z   - matrices containing the coordinates
%           of a grid of points covering the
%           surface of the solid
% v       - volume of the solid
% rc      - centroidal coordinate vector of the
%           solid
% vrr     - inertial tensor for the solid with the
%           mass density taken as unity
%
% User functions called: scatripl proptet
%-----------------------------------------------

% p=inline(...
%  'v*(eye(3)*(r(:)''*r(:))-r(:)*r(:)'')','v','r');

%d=mean([x(:),y(:),z(:)]); 
%x=x-d(1); y=y-d(2); z=z-d(3);

[n,m]=size(x); i=1:n-1; I=i+1; j=1:m-1; J=j+1;
xij=x(i,j); yij=y(i,j); zij=z(i,j);
xIj=x(I,j); yIj=y(I,j); zIj=z(I,j);
xIJ=x(I,J); yIJ=y(I,J); zIJ=z(I,J);
xiJ=x(i,J); yiJ=y(i,J); ziJ=z(i,J);

% Tetrahedron volumes
v1=scatripl(xij,yij,zij,xIj,yIj,zIj,xIJ,yIJ,zIJ);
v2=scatripl(xij,yij,zij,xIJ,yIJ,zIJ,xiJ,yiJ,ziJ);
v=sum(sum(v1+v2));

% First moments of volume
X1=xij+xIj+xIJ; X2=xij+xIJ+xiJ;
Y1=yij+yIj+yIJ; Y2=yij+yIJ+yiJ;
Z1=zij+zIj+zIJ; Z2=zij+zIJ+ziJ;
vx=sum(sum(v1.*X1+v2.*X2));
vy=sum(sum(v1.*Y1+v2.*Y2));
vz=sum(sum(v1.*Z1+v2.*Z2));

% Second moments of volume
vrr=proptet(v1,xij,yij,zij,xIj,yIj,zIj,...
    xIJ,yIJ,zIJ,X1,Y1,Z1)+...
    proptet(v2,xij,yij,zij,xIJ,yIJ,zIJ,...
    xiJ,yiJ,ziJ,X2,Y2,Z2);
rc=[vx,vy,vz]/v/4; vs=sign(v);
v=abs(v)/6; vrr=vs*vrr/120;
vrr=[vrr([1 4 5]), vrr([4 2 6]), vrr([5 6 3])]';
vrr=eye(3,3)*sum(diag(vrr))-vrr;

%vrr=vrr-p(v,rc)+p(v,rc+d); rc=rc+d;

%===========================================

function v=scatripl(ax,ay,az,bx,by,bz,cx,cy,cz)
%
% v=scatripl(ax,ay,az,bx,by,bz,cx,cy,cz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Scalar triple product dot(cross(a,b),c) where
% the cartesian components of vectors a,b,and c
% are given in arrays of the same size.
v=ax.*(by.*cz-bz.*cy)+ay.*(bz.*cx-bx.*cz)...
  +az.*(bx.*cy-by.*cx);

% =========================================

function vrr=tensprod(v,x,y,z)
%
% vrr=tensprod(v,x,y,z)
% ~~~~~~~~~~~~~~~~~~~~
% This function forms the various components
% of v*R*R'. The calculation is vectorized
% over arrays of points
vxx=sum(sum(v.*x.*x)); vyy=sum(sum(v.*y.*y));
vzz=sum(sum(v.*z.*z)); vxy=sum(sum(v.*x.*y));
vxz=sum(sum(v.*x.*z)); vyz=sum(sum(v.*y.*z));
vrr=[vxx; vyy; vzz; vxy; vxz; vyz];

% =========================================

function vrr=proptet(v,x1,y1,z1,x2,y2,z2,...
                     x3,y3,z3,xc,yc,zc)
%                   
% vrr=proptet(v,x1,y1,z1,x2,y2,z2,x3,y3,z3,...
%                                    xc,yc,zc)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes tensor properties of a
% tetrahedron with its base being a triangular
% surface and its apex at the origin
vrr=tensprod(v,x1,y1,z1)+tensprod(v,x2,y2,z2)+...
    tensprod(v,x3,y3,z3)+tensprod(v,xc,yc,zc);