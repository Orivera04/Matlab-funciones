function [dbest,r,R]= cylclose(srchtype,...
                    ntrials,sidlen,tolx,tolf)
% [dbest,r,R]= cylclose(srchtype,ntrials,...
%                           sidlen,tolx,tolf)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This program locates the points closest
% together on the surfaces of two circular 
% cylinders arbitrarily positioned in space.
% A four-dimensional unconstrained search
% is performed using functions NELMED,
% FMINSEARCH, or SURF2SURF. The quantity
% minimized is the square of the distance
% from an arbitrary point on one cylinder
% to an arbitrary point on the other cylinder.
% The search parameters specify axial and 
% circumferential coordinates of points on
% the cylinder surfaces. 
%
% srchtype - selects the solution method. Use
%            1,2, or 3 for NELMED, FMINSEARCH,
%            or SURF2SURF
% ntrials  - Number of times the solution is
%            repeated to avoid false 
%            convergence
% sidlen   - initial polyhedron side length
% tolx     - Convergence tolerance on solution
%            vector
% tolf     - Convergence tolerance on function
%            value
%
% User m functions called: 
%      cylpoint, dcyl2cyl, cylfigs, plot2cyls
%      cylpts, cornrpts, ortbasis, nelmed,
%      surfmany, surf2surf, srf2srf, rads

if nargin<5, tolf=1e-4;  end
if nargin<4, tolx=1e-2;  end
if nargin<3, sidlen=.5;  end
if nargin<2, ntrials=8;  end
if nargin<1, srchtype=1; end

if srchtype==1
  fname='FUNCTION NELMED';
elseif srchtype==2
  fname='FUNCTION FMINSEARCH'; 
else 
  fname='EXHAUSTIVE SEARCH';
end

disp(' '),
disp(' CYLINDER PROXIMITY ANALYSIS')
disp('USING A FOUR-DIMENSIONAL SEARCH')

cylfigs, drawnow, disp(' '), dumy=input(...
'Press return to begin the search','s');
close; ncases=4;

for jcase=1:ncases
  disp(' '), disp(['CASE ',...
      num2str(jcase),' USING ',fname])
  
  % Define several data cases 
  switch jcase
  case 1
    rad=1; len=3; r0=[4,0,0]; v=[0,0,1];
    Rad=1; Len=3; R0=[0,4,0]; V=[0,0,1];
  case 2
    rad=1; len=3; r0=[4,0,0]; v=[3,0,4];
    Rad=1; Len=3; R0=[0,4,0]; V=[0,3,4];
  case 3
    rad=1; len=5; r0=[4,0,0]; v=[-4,0,3];
    Rad=1; Len=5; R0=[0,4,0]; V=[0,0,1];
  case 4
    rad=1; len=4*sqrt(2); r0=[4,0,0];
    v=[-1,1,0];
    Rad=1; Len=3; R0=[0,0,-2]; V=[0,0,-1];
  end

  % Create data parameters used repeatedly 
  % during the search process

  % First cylinder
  dat=cumsum([0;rad;len;rad]);
  dat=dat/max(dat); zdat=[dat,[0;0;len;len]];
  rdat=[dat,[0;rad;rad;0]]; m=ortbasis(v);

  % Second cylinder
  dat=cumsum([0;Rad;Len;Rad]);
  dat=dat/max(dat); Zdat=[dat,[0;0;Len;Len]];
  Rdat=[dat,[0;Rad;Rad;0]]; M=ortbasis(V);

  % Make several searches starting from 
  % randomly chosen points and keep
  % the best answer obtained
  ntotal=0; ntype=zeros(1,5); disp(' ')
  tic; dbest=realmax; opts=optimset;
  if srchtype<3   
    disp('Trial    Minimum    Function')
    disp('Number   Distance  Evaluations')
    for k=1:ntrials
      winit=2*pi*rand(4,1);
      if srchtype==1 % Search using nelmed
        [w,fmin,nvals,ntyp]=nelmed(@dcyl2cyl,...
             winit,sidlen,tolx,tolf,2000,0,...
             r0,m,rdat,zdat,R0,M,Rdat,Zdat);
      elseif srchtype==2 % Search using fminsearch
        [w,fmin,xflag,outp]=fminsearch(@dcyl2cyl,...
        winit,opts,r0,m,rdat,zdat,R0,M,Rdat,Zdat);
        nvals=outp.funcCount; ntyp=zeros(1,5);
      end
      dk=sqrt(dcyl2cyl(w,r0,m,rdat,zdat,...
                             R0,M,Rdat,Zdat));
      fprintf('%4i   %8.3f   %7i\n',k,dk,nvals)
      if dk<dbest, dbest=dk; W=w; end
      ntotal=ntotal+nvals; ntype=ntype+ntyp;
    end
    w=W; r=cylpoint(w(1),w(2),r0,m,rdat,zdat);
    R=cylpoint(w(3),w(4),R0,M,Rdat,Zdat);
    t=toc; 
    fprintf(['\nThe analysis used ',fname,'\n'])
    %if srchtype==1
    %  fprintf(['\nReflect  Expand  Contract  ',...
    %  'Shrink \n%4i %7i %9i %7i\n'],ntype(2),...
    %  ntype(3),ntype(4),ntype(5))
    %end 
  else
    dplot=0.3; tic;
    [x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,...
    Rad,Len,R0,V,dplot,' '); close;
    [dbest,r,R]=surf2surf(x,y,z,X,Y,Z); 
    ntotal=length(x)*length(X); t=toc;
  end
  fprintf(...
  ['Shortest Distance    = %8.3f\n',...
   'Function Evaluations = %8i\n',...
   'Compute Time         = %8.3f secs\n'],...
   dbest,ntotal,t)
  
  n=1; Rr=repmat(R,1,n+1)+(r-R)*(0:n)/n; 
  hold off; clf,
  titl=['CASE ',num2str(jcase),' USING ',fname];
  dplot=0.3; plot2cyls(...
        rad,len,r0,v,Rad,Len,R0,V,dplot,titl);
  colormap([1 1 0]), hold on, 
  plot3(Rr(1,:),Rr(2,:),Rr(3,:),'linewidth',2)
  title([titl,' : DISTANCE = ',...
  num2str(dbest),',  CPU TIME = ',...
  num2str(t),' SECS'])
  rotate3d on, shg, disp(' ')
  disp('Rotate the figure or press')
  disp('return to continue') 
  dumy=input(' ','s'); close

end 

%===========================================

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

%===========================================

function dsqr=dcyl2cyl(...
              w,r0,m,rdat,zdat,R0,M,Rdat,Zdat)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
% dsqr=dcyl2cyl(w,r0,m,rdat,zdat,R0,M,Rdat,Zdat)
% This function computes the square of the 
% distance between generic points on the
% surfaces of two circular cylinders in three
% dimensions. 
%
% User m functions called: cylpoint

global fcount
fcount=fcount+1;
r=cylpoint(w(1),w(2),r0,m,rdat,zdat); 
R=cylpoint(w(3),w(4),R0,M,Rdat,Zdat);
dsqr=norm(r-R)^2;

%===========================================

function cylfigs
% cylfigs
% ~~~~~~~
% This function plots the geometries 
% pertaining to four data cases used 
% to test closest proximity problems 
% involving two circular cylinders
%
% User m functions called: plot2cyls

w=rads; p=1:2; q=3:4; s=5:6; t=7:8;

rad=1; len=3; r0=[4,0,0]; v=[0,0,1];
Rad=1; Len=3; R0=[0,4,0]; V=[0,0,1];
d=.4; subplot(2,2,1)
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 1'); hold on
plot3(w(p,1),w(p,2),w(p,3),'linewidth',2')  
hold off

rad=1; len=3; r0=[4,0,0]; v=[3,0,4];
Rad=1; Len=3; R0=[0,4,0]; V=[0,3,4];
d=.4; subplot(2,2,2);
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 2'); hold on
plot3(w(q,1),w(q,2),w(q,3),'linewidth',2')  
hold off

rad=1; len=5; r0=[4,0,0]; v=[-4,0,3];
Rad=1; Len=5; R0=[0,4,0]; V=[0,0,1];
d=.4; subplot(2,2,3)
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 3'); hold on
plot3(w(s,1),w(s,2),w(s,3),'linewidth',2')  
hold off

rad=1; len=4*sqrt(2);  r0=[4,0,0]; v=[-1,1,0];
Rad=1; Len=3; R0=[0,0,-2]; V=[0,0,-1];
d=.4; subplot(2,2,4);
[x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,v,Rad,Len,...
              R0,V,d,'CASE 4'); hold on
plot3(w(t,1),w(t,2),w(t,3),'linewidth',2')  
hold off, subplot
% print -deps cylclose

%===========================================

function [x,y,z,X,Y,Z]=plot2cyls(...
             rad,len,r0,vc,Rad,Len,R0,Vc,d,titl)
% [x,y,z,X,Y,Z]=plot2cyls(rad,len,r0,vc,Rad,...
%                         Len,R0,Vc,d,titl)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function generates point grids on the
% surfaces of two circular cylinders and plots
% both cylinders together
%
% User m functions called: cornrpts surfmany
%                          cylpts  
if nargin==0
   titl='TWO CYLINDERS';
   rad=1; len=3; r0=[4,0,0]; vc=[3,0,4];
   Rad=1; Len=3; R0=[0,4,0]; Vc=[0,3,4]; d=.2;
end
if isempty(titl), titl=' '; end
u=2*rad+len; v=2*pi*rad;
nu=ceil(u/d); nv=ceil(v/d);
u=cornrpts([0,rad,rad+len,u],nu)/u;
v=linspace(0,1,nv);
[x,y,z]=cylpts(u,v,rad,len,r0,vc); 
U=2*Rad+Len; V=2*pi*Rad;
Nu=ceil(U/d); Nv=ceil(V/d);
U=cornrpts([0,Rad,Rad+Len,U],Nu)/U;
V=linspace(0,1,Nv);
[X,Y,Z]=cylpts(U,V,Rad,Len,R0,Vc);
surfmany(x,y,z,X,Y,Z), title(titl)
colormap([1 1 0]), shg

%===========================================

function [x,y,z]=cylpts(...
                 axial,circum,rad,len,r0,vectax)
% [x,y,z]=cylpts(axial,circum,rad,len,r0,vectax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes a grid of points on the 
% surface of a circular cylinder
%
% User m functions called: ortbasis

U=2*rad+len; u=U*axial(:); n=length(u);
v=2*pi*circum(:)'; m=length(v);
ud=[0,rad,rad+len,U];
r=interp1(ud,[0,rad,rad,0],u);
z=interp1(ud,[0,0,len,len],u);
x=r*cos(v); y=r*sin(v); z=repmat(z,1,m); 
% w=basis(vectax)*[x(:),y(:),z(:)]';
w=ortbasis(vectax)*[x(:),y(:),z(:)]';

x=r0(1)+reshape(w(1,:),n,m); 
y=r0(2)+reshape(w(2,:),n,m);
z=r0(3)+reshape(w(3,:),n,m);

%===========================================

function v=cornrpts(u,N)
% v=cornrpts(u,N)
% ~~~~~~~~~~~~~~
% This function generates approximately N
% points between min(u) and max(u) including 
% all points in u plus additional points evenly
% spaced in each successive interval.
% u   -  vector of points
% N   -  approximate number of output points
%        between min(u(:)) and max(u(:))
% v   -  vector of points in increasing order 

u=sort(u(:))'; np=length(u);
d=u(np)-u(1); v=u(1);
for j=1:np-1
  dj=u(j+1)-u(j); nj=max(1,fix(N*dj/d)); 
  v=[v,[u(j)+dj/nj*(1:nj)]];
end

%===========================================

function mat=ortbasis(v)
% mat=ortbasis(v) 
% ~~~~~~~~~~~~~~
% This function generates a rotation matrix
% having v(:)/norm(v) as the third column

v=v(:)/norm(v); mat=[null(v'),v]; 
if det(mat)<0, mat(:,1)=-mat(:,1); end

%===========================================

function [xmin,fmin,m,ntype]=nelmed(...
              F,x0,dx,epsx,epsf,M,ifpr,varargin)
% [xmin,fmin,m,ntype]=nelmed(...
%             F,x0,dx,epsx,epsf,M,ifpr,varargin)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function performs multidimensional
% unconstrained function minimization using the
% direct search procedure developed by 
% J. A. Nelder and R. Mead. The method is 
% described in various books such as: 
% 'Nonlinear Optimization', by M. Avriel
% 
% F        - objective function of the form
%            F(x,p1,p2,...) where x is vector 
%            in n space and p1,p2,... are any
%            auxiliary parameters needed to
%            define F
% x0       - starting vector to initiate 
%            the search
% dx       - initial polyhedron side length
% epsx     - convergence tolerance on x
% epsf     - convergence tolerance on 
%            function values
% M        - function evaluation limit to
%            terminate search
% ifpr     - when this parameter equals one,
%            different stages in the search
%            are printed
% varargin - variable length list of parameters
%            which can be passed to function F
% xmin     - coordinates of the smallest 
%            function value
% fmin     - smallest function value found
% m        - total number of function 
%            evaluations made
% ntype    - a vector containing
%            [ninit,nrefl,nexpn,ncontr,nshrnk]
%            which tells the number of reflect-
%            ions, expansions, contractions,and
%            shrinkages performed
%
% User m functions called: objective function 
%                  named in the argument list

if isempty(ifpr), ifpr=0; end
if isempty(M), M=500; end;
if isempty(epsf), epsf=1e-5; end
if isempty(epsx), epsx=1e-5; end

% Initialize the simplex array
x0=x0(:); n=length(x0); N=n+1; f=zeros(1,N);
x=repmat(x0,1,N)+[zeros(n,1),dx*eye(n,n)];
for k=1:N
  f(k)=feval(F,x(:,k),varargin{:});
end

ninit=N; nrefl=0; nexpn=0; ncontr=0; 
nshrnk=0; m=N; 

Erx=realmax; Erf=realmax; 
alpha=1.0; % Reflection coefficient
beta= 0.5; % Contraction coefficient
gamma=2.0; % Expansion coefficient

% Top of the minimization loop

while Erx>epsx | Erf>epsf 

  [f,k]=sort(f); x=x(:,k);

  % Exit if maximum allowable number of
  % function values is exceeded
  if m>M, xmin=x(:,1); fmin=f(1); return; end

  % Generate the reflected point and 
  % function value
  c=sum(x(:,1:n),2)/n; xr=c+alpha*(c-x(:,N));
  fr=feval(F,xr,varargin{:}); m=m+1;
  nrefl=nrefl+1;
  if ifpr==1, fprintf(' :RFL \n'); end

  if fr<f(1) 
    % Expand and take best from expansion
    % or reflection
    xe=c+gamma*(xr-c); 
    fe=feval(F,xe,varargin{:});
    m=m+1; nexpn=nexpn+1; 
    if ifpr==1, fprintf(' :EXP \n'); end

    if fr<fe
      % The reflected point was best
      f(N)=fr; x(:,N)=xr; 
    else
      % The expanded point was best
      f(N)=fe; x(:,N)=xe; 
    end

  elseif fr<=f(n)  % In the middle zone
    f(N)=fr; x(:,N)=xr;

  else
    % Reflected point exceeds the second 
    % highest value so either use contraction
    % or shrinkage
    if fr<f(N)
      xx=xr; ff=fr; 
    else
      xx=x(:,N); ff=f(N); 
    end

    xc=c+beta*(xx-c);
    fc=feval(F,xc,varargin{:});
    m=m+1; ncontr=ncontr+1;
    
    if fc<=ff
      % Accept the contracted value
      x(:,N)=xc; f(N)=fc;
      if ifpr==1, fprintf(' :CNT \n'); end

    else
      % Shrink the simplex toward 
      % the best point
      x=(x+repmat(x(:,1),1,N))/2;
      for j=2:N
        f(j)=feval(F,x(:,j),varargin{:});
      end
      m=m+n; nshrnk=nshrnk+n;
      if ifpr==1, fprintf(' :SHR \n'); end
    end
  end
  
  % Evaluate parameters to check convergence
  favg=sum(f)/N; Erf=sqrt(sum((f-favg).^2)/n);
  xcent=sum(x,2)/N; xdif=x-repmat(xcent,1,N);
  Erx=max(sqrt(sum(xdif.^2)));
    
end % Bottom of the optimization loop

xmin=x(:,1); fmin=f(1);
ntype=[ninit,nrefl,nexpn,ncontr,nshrnk]; 

%=================================================

function [d,r,R]=surf2surf(x,y,z,X,Y,Z,n)
% [d,r,R]=surf2surf(x,y,z,X,Y,Z,n)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines the closest points on two
% surfaces and the distance between these points. It
% is similar to function srf2srf except that large
% arrays can be processed. 
%
% x,y,z  -  arrays of points on the first surface
% X,Y,Z  -  arrays of points on the second surface
% d      -  the minimum distance between the surfaces
% r,R    -  vectors containing the coordinates of the
%           nearest points on the first and the 
%           second surface 
% n      -  length of subvectors used to process the
%           data arrays. Sending vectors of length
%           n to srf2srf and taking the best of the
%           subresults allows processing of large
%           arrays of data points
%
% User m functions used: srf2srf

if nargin<7, n=500; end
N=prod(size(x)); M=prod(size(X)); d=realmax;
kN=max(1,floor(N/n)); kM=max(1,floor(M/n));
for i=1:kN
  i1=1+(i-1)*n; i2=min(i1+n,N); i12=i1:i2;
  xi=x(i12); yi=y(i12); zi=z(i12);
  for j=1:kM
    j1=1+(j-1)*n; j2=min(j1+n,M); j12=j1:j2;
    [dij,rij,Rij]=srf2srf(...
                  xi,yi,zi,X(j12),Y(j12),Z(j12));
    if dij<d, d=dij; r=rij; R=Rij; end
  end
end

%=================================================

function [d,r,R]=srf2srf(x,y,z,X,Y,Z)
% [d,r,R]=srf2srf(x,y,z,X,Y,Z)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines the closest points on two
% surfaces and the distance between these points.
% x,y,z  -  arrays of points on the first surface
% X,Y,Z  -  arrays of points on the second surface
% d      -  the minimum distance between the surfaces
% r,R    -  vectors containing the coordinates of the
%           nearest points on the first and the 
%           second surface  

x=x(:); y=y(:); z=z(:); n=length(x); v=ones(n,1); 
X=X(:)'; Y=Y(:)'; Z=Z(:)'; N=length(X); h=ones(1,N);
d2=(x(:,h)-X(v,:)).^2; d2=d2+(y(:,h)-Y(v,:)).^2;
d2=d2+(z(:,h)-Z(v,:)).^2;
[u,i]=min(d2); [d,j]=min(u); i=i(j); d=sqrt(d);
r=[x(i);y(i);z(i)]; R=[X(j);Y(j);Z(j)];

%=================================================

function R=rads
% R=rads
% Radii for the problem solutions

R=[...
0.7045    3.2903    0.8263
3.2932    0.7074    0.8295
0.7783    3.4977    0.3767
3.4994    0.7800    0.3755
0.0026    3.0000    2.9934
0.0028    1.0000    3.0001
0.7034    0.7107   -2.0000
1.5139    1.5320   -0.7382];

%=================================================

% surfmany(x1,y1,z1,x2,y2,z2,x3,y3,z3,...
%          xn,yn,zn)
% See Appendix B