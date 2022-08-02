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