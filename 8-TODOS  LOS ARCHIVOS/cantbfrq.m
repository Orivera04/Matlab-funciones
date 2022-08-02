function cantbfrq      
% Example:  cantbfrq
% ~~~~~~~~~~~~~~~~
% This program computes approximate natural 
% frequencies of a uniform depth cantilever 
% beam using finite difference and finite 
% element methods. Error results are presented 
% which demonstrate that the finite element 
% method is much more accurate than the finite 
% difference method when the same matrix orders
% are used in computation of the eigenvalues.
%
% User m functions required: 
%   cbfrqnwm, cbfrqfdm, cbfrqfem, frud, 
%   examplmo, animate, plotsave, inputv

clear;
fprintf('\n\n');
fprintf('CANTILEVER BEAM FREQUENCIES BY ');
fprintf('FINITE DIFFERENCE AND');
fprintf(...
'\n           FINITE ELEMENT APPROXIMATION\n');

fprintf('\nGive the number of frequencies ');
fprintf('to be computed');
fprintf('\n(use an even number greater ');
fprintf('than 2)\n'), n=input('? > ');
if rem(n,2) ~= 0, n=n+1; end

% Exact frequencies from solution of 
% the frequency equation
wex = cbfrqnwm(n,1e-12);

% Frequencies for the finite 
% difference solution
wfd = cbfrqfdm(n);

% Frequencies, modal vectors, mass matrix, 
% and stiffness matrix from the finite 
% element solution.
nelts=n/2; [wfe,mv,mm,kk] = cbfrqfem(nelts);
pefdm=(wfd-wex)./(.01*wex); 
pefem=(wfe-wex)./(.01*wex);

nlines=17; nloop=round(n/nlines);
v=[(1:n)',wex,wfd,pefdm,wfe,pefem];
disp(' '); lo=1;
t1=[' freq.     exact.        fdif.' ...
    '       fd. pct.'];
t1=[t1,'    felt.       fe. pct.'];
t2=['number     freq.         freq.' ...
    '        error  '];
t2=[t2,'    freq.        error  '];
while lo < n
  disp(t1),disp(t2); hi=min(lo+nlines-1,n);
  for j=lo:hi
    s1=sprintf('\n %4.0f %13.5e %13.5e', ...
               v(j,1),v(j,2),v(j,3));
    s2=sprintf(' %9.3f %13.5e %9.3f', ...
               v(j,4),v(j,5),v(j,6));
    fprintf([s1,s2]);
  end
  fprintf('\n\nPress [Enter] to continue\n\n');
  pause; lo=lo+nlines;
end
plotsave(wex,wfd,pefdm,wfe,pefem);
nfe=length(wfe); nmidl=nfe/2;
if rem(nmidl,2)==0, nmidl=nmidl+1; end
x0=zeros(nfe,1); v0=x0; w=0;
f1=zeros(nfe,1); f2=f1; f1(nfe-1)=1; 
f1(nmidl)=-5;
xsav=examplmo(mm,kk,f1,f2,x0,v0,wfe,mv);
close; fprintf('All Done\n');

%=============================================

function z=cbfrqnwm(n,tol)
%
% z=cbfrqnwm(n,tol)
% ~~~~~~~~~~~~~~~~~
% Cantilever beam frequencies by Newton's 
% method.  Zeros of 
%        f(z) = cos(z) + 1/cosh(z)  
% are computed.
%
% n   - Number of frequencies required
% tol - Error tolerance for terminating 
%       the iteration
% z   - Dimensionless frequencies are the 
%       squares of the roots of f(z)=0
%
% User m functions called:  none
%----------------------------------------------

if nargin ==1, tol=1.e-5; end

% Base initial estimates on the asymptotic 
% form of the frequency equation
zbegin=((1:n)-.5)'*pi; zbegin(1)=1.875; big=10;

% Start Newton iteration
while big > tol
  t=exp(-zbegin); tt=t.*t; 
  f=cos(zbegin)+2*t./(1+tt);
  fp=-sin(zbegin)-2*t.*(1-tt)./(1+tt).^2; 
  delz=-f./fp;
  z=zbegin+delz; big=max(abs(delz)); zbegin=z;
end
z=z.*z;

%=============================================

function [wfindif,mat]=cbfrqfdm(n)
%
% [wfindif,mat]=cbfrqfdm(n)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes approximate cantilever
% beam frequencies by the finite difference 
% method. The truncation error for the 
% differential equation and boundary 
% conditions are of order h^2.
%
% n       - Number of frequencies to be 
%           computed
% wfindif - Approximate frequencies in 
%           dimensionless form
% mat     - Matrix having eigenvalues which 
%           are the square roots of the 
%           frequencies
%
% User m functions called:  none
%----------------------------------------------

% Form the primary part of the frequency matrix
mat=3*diag(ones(n,1))-4*diag(ones(n-1,1),1)+...
    diag(ones(n-2,1),2); mat=(mat+mat');

% Impose left end boundary conditions 
% y(0)=0 and y'(0)=0
mat(1,[1:3])=[7,-4,1]; mat(2,[1:4])=[-4,6,-4,1];

% Impose right end boundary conditions
% y''(1)=0 and y'''(1)=0
mat(n-1,[n-3:n])=[1,-4,5,-2]; 
mat(n,[n-2:n])=[2,-4,2];

% Compute approximate frequencies and 
% sort these values
w=eig(mat); w=sort(w); h=1/n; 
wfindif=sqrt(w)/(h*h);

%=============================================

function [wfem,modvecs,mm,kk]= ...
                     cbfrqfem(nelts,mas,len,ei)
%
% [wfem,modvecs,mm,kk]=
%                    cbfrqfem(nelts,mas,len,ei)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Determination of natural frequencies of a 
% uniform depth cantilever beam by the Finite 
% Element Method.
%
%  nelts   - number of elements in the beam
%  mas     - total beam mass
%  len     - total beam length
%  ei      - elastic modulus times moment 
%            of inertia
%  wfem    - dimensionless circular frequencies
%  modvecs - modal vector matrix
%  mm,kk   - reduced mass and stiffness 
%            matrices
%
% User m functions called:  none
%----------------------------------------------

if nargin==1, mas=1; len=1; ei=1; end
n=nelts; le=len/n; me=mas/n; 
c1=6/le^2; c2=3/le; c3=2*ei/le;

% element mass matrix
masselt=me/420* ...
        [   156,   22*le,     54,  -13*le
          22*le,  4*le^2,  13*le, -3*le^2
             54,   13*le,    156,  -22*le
         -13*le, -3*le^2, -22*le,  4*le^2];

% element stiffness matrix
stifelt=c3*[ c1,  c2,  -c1,  c2
             c2,   2,  -c2,   1
            -c1, -c2,   c1, -c2
             c2,   1,  -c2,   2];

ndof=2*(n+1); jj=0:3; 
mm=zeros(ndof);  kk=zeros(ndof);

% Assemble equations
for i=1:n
  j=2*i-1+jj; mm(j,j)=mm(j,j)+masselt;
  kk(j,j)=kk(j,j)+stifelt;
end

% Remove degrees of freedom for zero 
% deflection and zero slope at the left end.
mm=mm(3:ndof,3:ndof); kk=kk(3:ndof,3:ndof);

% Compute frequencies
if nargout ==1
  wfem=sqrt(sort(real(eig(mm\kk))));
else
  [modvecs,wfem]=eig(mm\kk); 
  [wfem,id]=sort(diag(wfem));
  wfem=sqrt(wfem); modvecs=modvecs(:,id);
end

%=============================================

function [t,x]= ...
        frud(m,k,f1,f2,w,x0,v0,wn,modvc,h,tmax)
%
% [t,x]=frud(m,k,f1,f2,w,x0,v0,wn,modvc,h,tmax)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function employs modal superposition 
% to solve
%
%    m*x'' + k*x = f1*cos(w*t) + f2*sin(w*t)
%
% m,k    - mass and stiffness matrices
% f1,f2  - amplitude vectors for the forcing 
%          function
% w      - forcing frequency not matching any
%          natural frequency component in wn
% wn     - vector of natural frequency values
% x0,v0  - initial displacement and velocity 
%          vectors
% modvc  - matrix with modal vectors as its 
%          columns
% h,tmax - time step and maximum time for 
%          evaluation of the solution
% t      - column of times at which the 
%          solution is computed
% x      - solution matrix in which row j 
%          is the solution vector at 
%          time t(j)
%
% User m functions called:  none
%----------------------------------------------

t=0:h:tmax; nt=length(t); nx=length(x0); 
wn=wn(:); wnt=wn*t;

% Evaluate the particular solution.
x12=(k-(w*w)*m)\[f1,f2]; 
x1=x12(:,1); x2=x12(:,2);
xp=x1*cos(w*t)+x2*sin(w*t);

% Evaluate the homogeneous solution.
cof=modvc\[x0-x1,v0-w*x2]; 
c1=cof(:,1)'; c2=(cof(:,2)./wn)';
xh=(modvc.*c1(ones(1,nx),:))*cos(wnt)+...
   (modvc.*c2(ones(1,nx),:))*sin(wnt);

% Combine the particular and 
% homogeneous solutions.
t=t(:); x=(xp+xh)';

%=============================================

function x=examplmo(mm,kk,f1,f2,x0,v0,wfe,mv)
%
% x=examplmo(mm,kk,f1,f2,x0,v0,wfe,mv)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Evaluate the response caused when a downward
% load at the middle and an upward load at the 
% free end is applied.
%
% mm, kk - mass and stiffness matrices
% f1, f2 - forcing function magnitudes
% x0, v0 - initial position and velocity
% wfe    - forcing function frequency
% mv     - matrix of modal vectors
%
% User m functions called:  frud, animate, inputv
%----------------------------------------------

w=0; n=length(x0); t0=0; x=[];
s1=['\nEvaluate the time response from two',...
  '\nconcentrated loads. One downward at the',...
  '\nmiddle and one upward at the free end.'];
while 1
  fprintf(s1); fprintf('\n\n'); 
  fprintf('Input the time step and ');
  fprintf('the maximum time ');
  fprintf('\n(0.04 and 5.0) are typical.');
  fprintf(' Use 0,0 to stop\n');
  [h,tmax]=inputv; disp(' ');
  if norm([h,tmax])==0 | isnan(h), return; end

  [t,x]= ...
     frud(mm,kk,f1,f2,w,x0,v0,wfe,mv,h,tmax);
  x=x(:,1:2:n-1); x=[zeros(length(t),1),x];
  [nt,nc]=size(x); hdist=linspace(0,1,nc);

  clf; plot(t,x(:,nc),'k-');
  title('Position of the Free End of the Beam');
  xlabel('dimensionless time');
  ylabel('end deflection'); shg;
  disp('Press [Enter] for a surface plot of');
  disp(' transverse deflection versus x and t');
  pause
  print -deps endpos1 
  xc=linspace(0,1,nc); zmax=1.2*max(abs(x(:)));

  clf; surf(xc,t,x); view(30,35); 
  axis([0,1,0,tmax,-zmax,zmax]);
  xlabel('x axis'); ylabel('time'); 
  zlabel('deflection');
  title(['Cantilever Beam Deflection ' ...
       'for Varying Position and Time']); shg
  print -deps endpos2
  disp(['Press [Enter] to animate',...
        ' the beam motion']); pause
    
  titl='Cantilever Beam Animation'; 
  xlab='x axis'; ylab='displacement';
  animate(hdist,x,0.1,titl,xlab,ylab); close;
end

%=============================================

function animate(x,u,tpause,titl,xlabl,ylabl)
%
% animate(x,u,tpause,titl,xlabl,ylabl)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function draws an animated plot of data 
% values stored in array u.  The different 
% columns of u correspond to position values 
% in vector x.  The successive rows of u 
% correspond to different times. Parameter 
% tpause controls the speed of animation.
%
%  u      - matrix of values to animate plots 
%           of u versus x
%  x      - spatial positions for different 
%           columns of u
%  tpause - clock seconds between output of 
%           frames. The default is .1 secs 
%           when tpause is left out. When 
%           tpause=0, a new frame appears 
%           when the user presses any key.
%  titl   - graph title
%  xlabl  - label for horizontal axis
%  ylabl  - label for vertical axis
%
% User m functions called:  none
%----------------------------------------------
 
if nargin<6, ylabl=''; end; 
if nargin<5, xlabl=''; end
if nargin<4, titl=''; end; 
if nargin<3, tpause=.1; end;

[ntime,nxpts]=size(u); 
umin=min(u(:)); umax=max(u(:));
udif=umax-umin; uavg=.5*(umin+umax); 
xmin=min(x); xmax=max(x); 
xdif=xmax-xmin; xavg=.5*(xmin+xmax);
xwmin=xavg-.55*xdif; xwmax=xavg+.55*xdif;
uwmin=uavg-.55*udif; uwmax=uavg+.55*udif; clf;
axis([xwmin,xwmax,uwmin,uwmax]); title(titl);
xlabel(xlabl); ylabel(ylabl); hold on;

for j=1:ntime
  ut=u(j,:); plot(x,ut,'k-'); axis('off'); shg
  if tpause==0 
    pause; 
  else 
    pause(tpause); 
  end
  if j==ntime, break, else, cla; end
end
print -deps cntltrac
hold off; clf;

%=============================================

function plotsave(wex,wfd,pefd,wfe,pefem)
%
% function plotsave(wex,wfd,pefd,wfe,pefem)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function plots errors in frequencies 
% computed by two approximate methods.
%
% wex        - exact frequencies
% wfd        - finite difference frequencies
% wfe        - finite element frequencies
% pefd,pefem - percent errors by both methods
%
% User m functions called:  none
%----------------------------------------------

% plot results comparing accuracy 
% of both frequency methods
w=[wex(:);wfd(:);wfd]; 
wmin=min(w); wmax=max(w); n=length(wex);
wht=wmin+.001*(wmax-wmin); j=1:n;
 
semilogy(j,wex,'k-',j,wfe,'k--',j,wfd,'k:')
title('Cantilever Beam Frequencies');
xlabel('frequency number');
ylabel('frequency values');
legend('Exact freq.','Felt. freq.', ...
       'Fdif. freq.',2); figure(gcf); 
disp(['Press [Enter] for a frequency ',...
      'error plot']); pause 
print -deps beamfrq1 

plot(j,abs(pefd),'k:',j,abs(pefem),'k--');
title(['Cantilever Beam Frequency ' ...
       'Error Percentages']);
xlabel('frequency number'); 
ylabel('percent frequency error'); 
legend('Fdif. pct. error','Felt. pct. error',4);
figure(gcf);
disp(['Press [Enter] for a transient ',...
'response calculation']); pause
print -deps beamfrq2