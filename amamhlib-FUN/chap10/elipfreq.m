function [frqs,modes,indx,x,y,alpha,cptim]=elipfreq(...
                            a,b,type,nlsq,nfuns,noplot)
% [frqs,modes,indx,x,y,alpha,cptim]=elipfreq(...
%                           a,b,type,nlsq,nfuns,noplot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes natural frequencies and mode
% shapes for an elliptical membrane. Modes that are
% symmetrical or anti-symmetrical about the x axis are
% included. An approximate solution is obtained using 
% a separation of variables formulation in elliptical
% coordinates.  
%
% a,b       - the ellipse major and minor semi-
%             diameters along the x and y axes
% nlsq      - two-component vector giving the number
%             of least square points in the eta and
%             xi directions
% nfuns     - two-component vector giving the number of
%             functions used to solve the differential
%             equations for the eta and xi directions.
% type      - use 1 for even modes symmetric about the
%             x-axis. Use 2 for odd modes anti-
%             symmetric about the x-axis. Use 3 to
%             combine both even and odd modes.             
%
% frqs      - a vector of natural frequencies
%             arranged in increasing order.
% modes     - a three dimensional array in which
%             modes(:,:,j) defines the modal 
%             deflection surface for frequency
%             frqs(j).
% indx      - a vector telling whether each
%             mode is even (1) or odd (2)
% x,y       - curvilinear coordinate arrays of
%             points in the membrane where modal
%             function values are computed. 
% alpha     - a vector of eigenvalue parameters in
%             the Mathieu equation: u''(eta)+...
%             (alpha-lambda*cos(2*eta))*u(eta)=0
%             where lambda=(h*freq)^2/2 and 
%             h=atanh(b/a)
% cptim     - the cpu time in seconds used to 
%             form the equations and solve for
%             eigenvalues and eigenvectors
% noplot    - enter any value to skip mode plots
%
% User m functions called: 
%                     frqsimpl eigenrec plotmode
%                     modeshap funcxi funceta  
close
if nargin==0
   disp(' ')
   disp('VIBRATION MODE SHAPES AND FREQUENCIES')
   disp('       OF AN ELLIPTIC MEMBRANE       ')
   disp(' ')
      
   nlsq=[300,300]; nfuns=[25,25];
      
   v=input(['Input the major and minor ',...
         'semi-diameters > ? '],'s');
   v=eval(['[',v,']']); a=v(1); b=v(2); disp(' ')
   disp('Select the modal form option')
   type=input(...
      '1<=>even, 2<=>odd, 3<=>both > ? ');
   disp(' ')
   disp(['The computation takes awhile.',...
         ' PLEASE WAIT.'])
end

if type ==1 | type==2 % Even or odd modes
	[frqs,modes,x,y,alpha,cptim]=frqsimpl(...
		a,b,type,nlsq,nfuns);
  indx=ones(length(frqs),1)*type;
else % Both modes
   [frqs,modes,x,y,alpha,cptim]=frqsimpl(...
		 a,b,1,nlsq,nfuns);
   indx=ones(length(frqs),1);
   [frqso,modeso,x,y,alphao,cpto]=frqsimpl(...
		 a,b,2,nlsq,nfuns);
   frqs=[frqs;frqso]; alpha=[alpha;alphao];
	 modes=cat(3,modes,modeso);
   indx=[indx;2*ones(length(frqso),1)];
   [frqs,k]=sort(frqs); modes=modes(:,:,k);
   indx=indx(k); cptim=cptim+cpto;
end

if nargin==6, return, end

% Plot a sequence of modal functions
neig=length(frqs);
disp(' '), disp(['Computation time  = ',...
      num2str(sum(cptim)),' seconds.'])
disp(['Number of modes   = ',num2str(neig)]);
disp(['Highest frequency = ',...
      num2str(frqs(end))]), disp(' ')
disp('Press return to see modal plots.')
pause, plotmode(a,b,x,y,frqs,modes,indx)

%==============================================

function [frqs,Modes,x,y,alpha,cptim]=frqsimpl(...
	                                a,b,type,nlsq,nfuns)
% [frqs,Modes,x,y,alpha,cptim]=frqsimpl(...
%                                 a,b,type,nlsq,nfuns)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% a,b   - ellipse major and minor semi-diameters
% type  - numerical values of one or two for modes 
%         symmetric or anti-symmetric about the x axis
% nlsq  - vector [neta,nxi] giving the number of least
%         square points used for the eta and xi
%         directions
% nfuns - vector [meta,mxi] giving the number of 
%         approximating functions used for the eta and 
%         xi directions
% frqs  - natural frequencies arranged in increasing 
%         order
% Modes - modal surface shapes in the ellipse
% x,y   - coordinate points in the ellipse 
% alpha - vector of values for the eigenvalues in the
%         Mathieu differential equation:
%         u''(eta)+(alpha-lambda*cos(2*eta))*u(eta)=0
% cptim - vector of computation times
%
% User m functions called: funceta  funcxi 
%                          eigenrec modeshap
if nargin==0
	a=cosh(2); b=sinh(2); type=1;
  nlsq=[200,200]; nfuns=[30,30];
end
h=sqrt(a^2-b^2); R=atanh(b/a); neta=nlsq(1); alpha=[];
nxi=nlsq(2); meta=nfuns(1); mxi=nfuns(2); 
eta=linspace(0,pi,neta)'; xi=linspace(0,R,nxi)';
[Xi,Eta]=meshgrid(xi,eta); z=h*cosh(Xi+i*Eta);
x=real(z); y=imag(z); cptim=zeros(1,3);

% Form the Mathieu equation for the circumferential
% direction as: A*E+alpha*E-lambda*B*E=0
tic; [Veta,A]=funceta(meta,type,eta);
A=Veta\[A,repmat(cos(2*eta),1,meta).*Veta];
B=A(:,meta+1:end); A=A(:,1:meta);

% Form the modified Mathieu equation for the radial
% direction as: P*F-alpha*F+lambda*Q*F=0
[Vxi,P]=funcxi(a,b,mxi,type,xi);
P=Vxi\[P,repmat(cosh(2*xi),1,mxi).*Vxi];
Q=P(:,mxi+1:end); P=P(:,1:mxi);
cptim(1)=toc; tic

% Solve the eigenvalue problem. This takes most
% of the computation time
[frqs,modes]=eigenrec(P',A,-Q',B); 
% Keep only half of the modes and frequencies
nmax=fix(length(frqs)/2); frqs=frqs(1:nmax);
modes=modes(:,:,1:nmax); cptim(2)=toc; 

% Compute values of the second eigenvalue 
% parameter in Mathieu's equation
alpha=zeros(1,nmax); tic; 
s=size(modes); s=s(1:2); Vxi=Vxi';

% Obtain the modal surface shapes
Neta=91; Nxi=25; Modes=zeros(Neta,Nxi,nmax);
for k=1:nmax
	Mk=modes(:,:,k); [dmk,K]=max(abs(Mk(:)));
	[I,J]=ind2sub(s,K); Ej=Mk(:,J);
	alpha(k)=(B(I,:)*Ej*frqs(k)-A(I,:)*Ej)/Mk(K);
	[Modes(:,:,k),x,y]=modeshap(a,b,type,Mk,Nxi,Neta);
end
frqs=sqrt(2*frqs)/h; cptim(3)=toc;	

%==============================================

function [eigs,vecs,Amat,Bmat]=eigenrec(A,B,C,D)
% [eigs,vecs,Amat,Bmat]=eigenrec(A,B,C,D)
% Solve a rectangular eigenvalue problem of the
% form: X*A+B*X=lambda*(X*C+D*X)
%
% A,B,C,D - square matrices defining the problem.
%           A and C have the same size. B and D
%           have the same size. 
% eigs    - vector of eigenvalues
% vecs    - array of eigenvectors where vecs(:,:,j)
%           contains the rectangular eigenvector
%           for eigenvalue eigs(j)
% Amat,
% Bmat    - matrices that express the eigenvalue
%           problem as Amat*V=lambda*Bmat*V
%
n=size(B,1); m=size(A,2); s=[n,m]; N=n*m; 
Amat=zeros(N,N); Bmat=Amat; kn=1:n; km=1:m;
for i=1:n
  IK=sub2ind(s,i*ones(1,m),km);  
  Bikn=B(i,kn); Dikn=D(i,kn);
  for j=1:m
    I=sub2ind(s,i,j); 
    Amat(I,IK)=A(km,j)'; Bmat(I,IK)=C(km,j)'; 
    KJ=sub2ind(s,kn,j*ones(1,n));
    Amat(I,KJ)=Amat(I,KJ)+ Bikn;
    Bmat(I,KJ)=Bmat(I,KJ)+ Dikn;
   end
end
[vecs,eigs]=eig(Bmat\Amat); 
[eigs,k]=sort(diag(eigs));
vecs=reshape(vecs(:,k),n,m,N);

%===========================================

function plotmode(a,b,x,y,eigs,modes,indx)
%
% plotdmode(a,b,x,y,eigs,modes,indx)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function makes animated plots of the
% mode shapes of an elliptic membrane for
% various frequencies
% a,b    - major and minor semi-diameters
% x,y    - arrays of points defining the
%          curvilinear coordinate grid
% eigs   - vector of sorted frequencies
% modes  - array of modal surfaces for 
%          the corresponding frequencies
% indx   - vector of indices designating
%          each mode as even (1) or odd (2)

range=[-a,a,-b,b,-a,a]; 
nf=25; ft=cos(linspace(0,4*pi,nf));
boa=[',   B/A = ',num2str(b/a,4)];
while 1
   jlim=[];
   while isempty(jlim), disp(' ')
     disp(['Give a vector of mode ',...
           'indices (try 10:2:20) > ? ']);
     jlim=input('(input 0 to stop > ? ');
   end
   if any(jlim==0)
     disp(' '), disp('All done'), break, end
   for j=jlim
      if indx(j)==1, type='EVEN'; f=1;
      else, type ='ODD '; f=-1; end
      u=a/2*modes(:,:,j);
                  
      for kk=1:nf
         surf(x,y,ft(kk)*u)
         axis equal, axis(range)
         xlabel('x axis'), ylabel('y axis')
         zlabel('u(x,y)')
         title([type,' MODE ',num2str(j),...
         ',  OMEGA = ',num2str(eigs(j),4),boa])
         %colormap([127/255 1 212/255])
         colormap([1 1 0])
         drawnow, shg
      end
      pause(1);
   end
end

%==================================================

function [u,x,y]=modeshap(...
                       a,b,type,modemat,nxi,neta,H)
%
% [u,x,y]=modeshap(a,b,type,modemat,nxi,neta,H)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function uses the eigenvectors produced by
% the rectangular eigenvalue solver to form modal 
% surface shapes in cartesian coordinates.
% a,b      - major and minor semi-diameters
% type     - 1 for even, 2 for odd
% modemat  - eigenvector matrix output by eigenrec
% nxi,neta - number of radial and circumferential
%            coordinate values
% H        - maximum height of the modal surfaces.
%            The default value is one.
% u,x,y    - modal surface array and corresponding
%            cartesian coordinate matrices. u(:,:j)
%            gives the modal surface for the j'th
%            natural frequency.

if nargin<7, H=1; end
if nargin<6, neta=81; end; if nargin<5, nxi=22; end
h=sqrt(a^2-b^2); r=atanh(b/a); x=[]; y=[];
xi=linspace(0,r,nxi); eta=linspace(-pi,pi,neta);
if nargout>1  
  [Xi,Eta]=meshgrid(xi,eta); z=h*cosh(Xi+i*Eta);
  x=real(z); y=imag(z);
end
[Neta,Nxi]=size(modemat); 
mateta=funceta(Neta,type,eta);
matxi=funcxi(a,b,Nxi,type,xi);
u=mateta*modemat*matxi'; [umax,k]=max(abs(u(:)));
u=H/u(k)*u;

%==================================================

function [f,f2]=funcxi(a,b,n,type,xi)
%
% [f,f2]=funcxi(a,b,n,type,xi)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function defines the approximating functions
% for the radial direction
% a,b  - ellipse major and minor half-diameters
% n    - number of series terms used
% type - 1 for even valued, 2 for odd valued
% xi   - vector of radial coordinate values
% f,f2 - matrix of function and second derivative
%        values

xi=xi(:); nxi=length(xi); R=atanh(b/a);
if type==1, N=pi/R*(1/2:n); f=cos(xi*N); 
else, N=pi/R*(1:n); f=sin(xi*N); end
f2=-repmat(N.^2,nxi,1).*f; 

%==================================================

function [f,f2]=funceta(n,type,eta)
%
% [f,f2]=funceta(n,type,eta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function defines the approximating functions
% for the circumferential direction
% n    - number of series terms used
% type - 1 for even valued, 2 for odd valued
% xi   - vector of circumferential coordinate values
% f,f2 - matrix of function and second derivative
%        values

eta=eta(:); neta=length(eta);
if type==1, N=0:n-1; f=cos(eta*N);
else, N=1:n; f=sin(eta*N); end
f2=-repmat(N.^2,neta,1).*f;
