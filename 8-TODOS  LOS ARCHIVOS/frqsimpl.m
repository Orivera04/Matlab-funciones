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
%         u''(eta)+(alpha-lambda*cos(2*eta)*u(eta)=0
% cptim - vector of computation times
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

Neta=91; Nxi=25; Modes=zeros(Neta,Nxi,nmax);
for k=1:nmax
	Mk=modes(:,:,k); [dmk,K]=max(abs(Mk(:)));
	[I,J]=ind2sub(s,K); Ej=Mk(:,J);
	alpha(k)=(B(I,:)*Ej*frqs(k)-A(I,:)*Ej)/Mk(K);
	[Modes(:,:,k),x,y]=modeshap(a,b,type,Mk,Nxi,Neta);
end
frqs=sqrt(2*frqs)/h; cptim(3)=toc;	