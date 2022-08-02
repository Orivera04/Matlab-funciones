function [u,x,y,t]= membwave(type,dims,alp,w,tmax)
%
% [u,x,y,t]=membwave(type,dims,alp,w,tmax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This program illustrates waves propagating in
% a membrane of rectangular or circular shape
% with an oscillatory concentrated load acting at
% an arbitrary interior point. The membrane has 
% fixed edges and is initially undeflected and
% at rest. The response u(x,y,t) is computed and
% animated plots depicting the motion are shown.
% 
% type   -  1 for rectangle, 2 for circle
% dims   -  vector giving problem dimensions. For
%           type=1, dims=[a,b,x0,y0] where a and
%           b are rectangle dimensions along the
%           x and y axes. Also the oscillating
%           force acts at (x0,y0). For type=2,
%           a circular membrane of unit radius is
%           analyzed with the concentrated force
%           acting at (r0,0) where r0=dims(1);
% alp    -  wave propagation velocity in the
%           membrane
% w      -  frequency of the applied force. This
%           can be zero if the force is constant.
% x0,y0  -  coordinates of the point where
%           the force acts
% x,y,t  -  vectors of position and time values
%           for evaluation of the solution
% u      -  an array of size [length(x),...
%                          length(y),length(t)]
%           in which u(i,j,k) contains the
%           normalized displacement at 
%           y(i),x(j),t(k). The displacement is
%           normalized by dividing by 
%           max(abs(u(:)))

close, disp(' ')
disp('WAVE MOTION IN A RECTANGULAR OR CIRCULAR')
disp('  MEMBRANE HAVING AN OSCILLATING LOAD')

if nargin > 0 % Data passed through the call list
  % must specify: type, dims, alp, w, tmax
  % Typical values are: a=2; b=1; alp=1; 
  % w=18.4; x0=1; y0=0.5; tmax=5;
  if type==1
    a=dims(1); b=dims(2); x0=dims(3); y0=dims(4);
    [u,x,y,t]=memrecwv(a,b,alp,w,x0,y0,tmax);
  else
    r0=dims(1);
  end
else % Interactive data input
   
  disp(' '), disp('Select the geometry type:')   
  type=input(['Enter 1 for a rectangle, ',...
              '2 for a circle > ? ']);
  if type ==1
    disp(' ')
    disp('Specify the rectangle dimensions:')
    s=input('Give values for a,b > ? ','s');
    s=eval(['[',s,']']); a=s(1); b=s(2);
    disp(' ')
    disp('Give coordinates (x0,y0) where the')
    s=input('force acts. Enter x0,y0 > ? ','s'); 
    s=eval(['[',s,']']); x0=s(1); y0=s(2);     
    disp(' '), alp=input('Enter the wave speed > ? ');    
     
    N=40; M=40; pan=pi/a*(1:N)'; pbm=pi/b*(1:M);
    W=alp*sqrt(repmat(pan.^2,1,M)+repmat(pbm.^2,N,1));
    wsort=sort(W(:)); wsort=reshape(wsort(1:42),6,7)';
    disp(' ') 
    disp(['The first forty-two natural ',...
          'frequencies are:'])
    disp(wsort)
    w=input(...
    'Input the frequency of the forcing function ? ');

  else
    disp(' '), disp(...
    'The circle radius equals one. Give the radial')
    disp(...
    'distance r0 from the circle center to the')
    r0=input('force > ? '); 
          
    disp(' '), alp=input('Enter the wave speed > ? ');
     
    % First 42 Bessel function roots
    wsort=alp*[...
      2.4048  3.8317  5.1356  5.5201  6.3801  7.0156
      7.5883  8.4173  8.6537  8.7715  9.7611  9.9362
     10.1735 11.0647 11.0864 11.6199 11.7916 12.2251
     12.3385 13.0152 13.3237 13.3543 13.5893 14.3726
     14.4755 14.7960 14.8213 14.9309 15.5898 15.7002
     16.0378 16.2234 16.4707 16.6983 17.0037 17.2412
     17.6159 17.8014 17.9599 18.0711 18.2876 18.4335];
   
    disp(' '), disp(['The first forty-two ',...
                     'natural frequencies are:'])
    disp(wsort)
    w=input(...
    'Input the frequency of the forcing function ? ');
  end
   disp(' ')
   disp('Input the maximum solution evaluation time.')
   tmax=input(' > ? ');
end
 
if type==1
  [u,x,y,t]=memrecwv(a,b,alp,w,x0,y0,tmax);
else
  th=linspace(0,2*pi,81); r=linspace(0,1,20);
  [u,x,y,t]=memcirwv(r,th,r0,alp,w,tmax);
end
 
% Animate the solution
membanim(u,x,y,t);
 
%================================================ 
 
function [u,x,y,t]= memrecwv(a,b,alp,w,x0,y0,tmax)
%
% [u,x,y,t]=memrecwv(a,b,alp,w,x0,y0,tmax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function illustrates wave motion in a 
% rectangular membrane subjected to a concentrated
% oscillatory force applied at an arbitrary 
% interior point. The membrane has fixed edges 
% and is initially at rest in an undeflected 
% position. The resulting response u(x,y,t)is
% computed and a plot of the motion is shown.
% a,b    -  side dimensions of the rectangle
% alp    -  wave propagation velocity in the
%           membrane
% w      -  frequency of the applied force. This
%           can be zero if the force is constant.
% x0,y0  -  coordinates of the point where
%           the force acts
% x,y,t  -  vectors of position and time values
%           for evaluation of the solution
% u      -  an array of size [length(y),...
%           length(x),length(t)] in which u(i,j,k)
%           contains the normalized displacement
%           corresponding to y(i), x(j), t(k). The 
%           displacement is normalized by dividing 
%           by max(abs(u(:))).
%
% The solution is a double Fourier series of form 
%
% u(x,y,t)=Sum(A(n,m,x,y,t), n=1..N, m=1..M)
% where
% A(n,m,x,y,t)=sin(n*pi*x0/a)*sin(n*pi*x/a)*...
%              sin(m*pi*y0/b)*sin(m*pi*y/b)*...
%              (cos(w*t)-cos(W(n,m)*t))/...
%              ( w^2-W(n,m)^2)
% and the membrane natural frequencies are
% W(n,m)=pi*alp*sqrt((n/a)^2+(m/b)^2)

if nargin==0
  a=2; b=1; alp=1; tmax=3; w=13; x0=1.5; y0=0.5;
end
if a<b
   nx=31; ny=round(b/a*21); ny=ny+rem(ny+1,2);
else
   ny=31; nx=round(a/b*21); nx=nx+rem(nx+1,2);
end
x=linspace(0,a,nx); y=linspace(0,b,ny);

N=40; M=40; pan=pi/a*(1:N)'; pbm=pi/b*(1:M);
W=alp*sqrt(repmat(pan.^2,1,M)+repmat(pbm.^2,N,1));
wsort=sort(W(:)); wsort=reshape(wsort(1:30),5,6)';
Nt=ceil(40*tmax*alp/min(a,b)); 
t=tmax/(Nt-1)*(0:Nt-1);
  
% Evaluate fixed terms in the series solution  
mat=sin(x0*pan)*sin(y0*pbm)./(w^2-W.^2);
sxn=sin(x(:)*pan'); smy=sin(pbm'*y(:)');

u=zeros(ny,nx,Nt); 
for j=1:Nt
  A=mat.*(cos(w*t(j))-cos(W*t(j)));
  uj=sxn*(A*smy); u(:,:,j)=uj';
end

%================================================

function [u,x,y,t,r,th]=memcirwv(r,th,r0,alp,w,tmax)
%
% [u,x,y,t,r,th]=memcirwv(r,th,r0,alp,w,tmax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes the wave response in a
% circular membrane having an oscillating force
% applied at a point on the radius along the
% positive x axis.
%
% r,th - vectors of radius and polar angle values
% r0   - radial position of the concentrated force
% w    - frequency of the applied force
% tmax - maximum time for computing the solution
%
% User m function used: besjroot

if nargin==0 
  r0=.4; w=15.5; th=linspace(0,2*pi,81); 
  r=linspace(0,1,21); alp=1;
end

Nt=ceil(20*alp*tmax);  t=tmax/(Nt-1)*(0:Nt-1);

% Compute the Bessel function roots needed in 
% the series solution. This takes a while.
lam=besjroot(0:20,20,1e-3);

% Compute the series coefficients
[nj,nk]=size(lam); r=r(:)'; nr=length(r);
th=th(:); nth=length(th); nt=length(t);
N=repmat((0:nj-1)',1,nk); Nvec=N(:)';
c=besselj(N,lam*r0)./(besselj(...
   N+1,lam).^2.*(lam.^2-w^2));
c(1,:)=c(1,:)/2; c=c(:)';

% Sum the series of Bessel functions
lamvec=lam(:)'; wlam=w./lamvec;
c=cos(th*Nvec).*repmat(c,nth,1); 
rmat=besselj(repmat(Nvec',1,nr),lamvec'*r);
u=zeros(nth,nr,nt);
for k=1:nt   
  tvec=-cos(w*t(k))+cos(lamvec*t(k));
  u(:,:,k)=c.*repmat(tvec,nth,1)*rmat;
end
u=2/pi*u; x=cos(th)*r; y=sin(th)*r;

%================================================

function rts=besjroot(norder,nrts,tol)
%
% rts=besjroot(norder,nrts,tol)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes an array of positive roots
% of the integer order Bessel functions besselj of 
% the first kind for various orders. A chosen number
% of roots is computed for each order
% norder - a vector of function orders for which
%          roots are to be computed. Taking 3:5
%          for norder would use orders 3,4 and 5.
% nrts   - the number of positive roots computed for
%          each order. Roots at x=0 are ignored.
% rts    - an array of roots having length(norder)
%          rows and nrts columns. The element in
%          column k and row i is the k'th root of
%          the function besselj(norder(i),x).
% tol    - error tolerance for root computation.

if nargin<3, tol=1e-5; end
jn=inline('besselj(n,x)','x','n');
N=length(norder); rts=ones(N,nrts)*nan;
opt=optimset('TolFun',tol,'TolX',tol);
for k=1:N
   n=norder(k); xmax=1.25*pi*(nrts-1/4+n/2);
   xsrch=.1:pi/4:xmax; fb=besselj(n,xsrch);
   nf=length(fb); K=find(fb(1:nf-1).*fb(2:nf)<=0);
   if length(K)<nrts
      disp('Search error in function besjroot')
      rts=nan; return
   else
      K=K(1:nrts);
      for i=1:nrts
         interval=xsrch(K(i):K(i)+1);
         rts(k,i)=fzero(jn,interval,opt,n);
      end
   end
end   

%================================================

function membanim(u,x,y,t)
%
% function membanim(u,x,y,t)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function animates the motion of a 
% vibrating membrane
%
% u    array in which component u(i,j,k) is the
%      displacement for y(i),x(j),t(k)
% x,y  arrays of x and y coordinates
% t    vector of time values

% Compute the plot range
if nargin==0; 
  [u,x,y,t]=memrecwv(2,1,1,15.5,1.5,.5,5);
end
xmin=min(x(:)); xmax=max(x(:));
ymin=min(y(:)); ymax=max(y(:));
xmid=(xmin+xmax)/2; ymid=(ymin+ymax)/2;
d=max(xmax-xmin,ymax-ymin)/2; Nt=length(t);
range=[xmid-d,xmid+d,ymid-d,ymid+d,...
       3*min(u(:)),3*max(u(:))];

while 1 % Show the animation repeatedly
  disp(' '), disp('Press return for animation')
  dumy=input('or enter 0 to stop > ? ','s');
  if ~isempty(dumy)
    disp(' '), disp('All done'), break
  end

  % Plot positions for successive times
  for j=1:Nt
    surf(x,y,u(:,:,j)), axis(range)
    xlabel('x axis'), ylabel('y axis')
    zlabel('u axis'), titl=sprintf(...
    'MEMBRANE POSITION AT T=%5.2f',t(j));
    title(titl), colormap([1 1 1])
    colormap([127/255 1 212/255])
    % axis off
    drawnow, shg, pause(.1)
  end
end
