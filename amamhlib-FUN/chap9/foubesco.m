function [c,lam,cptim]=foubesco(...
                         f,nord,nrts,nrquad,nft)
%                       
% [c,lam,cptim]=foubesco(f,nord,nrts,nrquad,nft)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Fourier-Bessel coefficients computed using the
% FFT
global besjrt
if nargin<5, nft=128; end
if nargin<4, nrquad=50; end
if nargin<3, nrts=10; end
if nargin<2, nord=10; end
if nargin==0, f='fbes'; end 
tic; lam=besjrt(1:nord,1:nrts);
c=zeros(nord,nrts);
[dummy,r,w]=gcquad([],0,1,nrquad,1);
r=r(:)'; w=w(:)'; th=2*pi/nft*(0:nft-1)';
fmat=fft(feval(f,th,r));
fmat=fmat(1:nord,:).*repmat(r.*w,nord,1);
for n=1:nord
  for k=1:nrts
    lnk=lam(n,k);
    v=sum(fmat(n,:).*besselj(n-1,lnk*r));
    c(n,k)=4*v/nft/besselj(n,lnk).^2;
  end
end
c(1,:)=c(1,:)/2; cptim=toc;