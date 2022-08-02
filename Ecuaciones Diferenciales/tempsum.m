function [u,tcpu]=tempsum(c,th,r,t,lam)
%
% [u,tsum]=tempsum(c,th,r,t,lam)
%
% This function sums a Fourier-Bessel series
% for transient temperature history in a circular
% cylinder with given initial conditions and
% zero temperature at the boundary. The series
% has the form
% u(theta,r,t)=sum({n=0:nord-1),k=1:nrts},...
% besselj(n,lam(n+1,k)*r)*real(...
% c(n+1,k)*exp(i*(n+1)*theta))*...
% exp(-lam(n+1,k)^2*t), where
% besselj(n-1,lam(n,k))=0 and 
% [nord,nrts]=size(c)
% 
% c    - the series coefficients for the initial
%        temperature distribution obtained using
%        function foubesco
% th   - vector or theta values between
%        zero and 2*pi
% r    - vector of radius values between
%        zero and one
% lam  - matrix of bessel function roots.
%        If this argument is omitted, then
%        function besjroot is called to
%        compute the roots
% u    - a three-dimensional array of function
%        values where u(i,j,k) contains the 
%        temperature for theta(i), r(j), t(k)
% tcpu - computation time in seconds

tic; [nord,nrts]=size(c); 
if nargin<5, lam=besjroot(0:nord-1,nrts); end
th=th(:); nth=length(th); r=r(:)'; nr=length(r);
nt=length(t); N=repmat((0:nord-1)',1,nrts);
N=N(:)'; c=c(:).'; lam=lam(:); lam2=-(lam.^2)';
u=zeros(nth,nr,nt); thmat=exp(i*th*N);
besmat=besselj(repmat(N',1,nr),lam*r);
for I=1:nt
  C=c.*exp(lam2*t(I));
  u(:,:,I)=real(thmat.*repmat(C,nth,1))*besmat;
end
tcpu=toc;