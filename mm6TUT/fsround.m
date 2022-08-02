function K=fsround(kn,tol)
%FSROUND Round Fourier Series Coefficients. (MM)
% FSROUND(Kn) rounds the FS Kn to eliminate residual terms.
%
% Whole Terms set to zero satisfy: abs(Kn) < TOL*max(abs(Kn))
% 
% Real parts set to zero satisfy:
% abs(real(Kn)) < TOL*max(abs(real(Kn)))
% abs(real(Kn)) < TOL*abs(imag(Kn))
%
% Imaginary parts set to zero satisfy:
% abs(imag(Kn)) < TOL*max(abs(imag(Kn)))
% abs(imag(Kn)) < TOL*abs(real(Kn))
%
% TOL=sqrt(eps) or can be can be specified by FSROUND(Kn,TOL)
%
% See also FSHELP.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/2/95, revised 4/11/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2, tol=sqrt(eps); end
K=kn(:).';
mkn=abs(kn);
rkn=abs(real(kn));
ikn=abs(imag(kn));

i=find(mkn<tol*max(mkn));
K(i)=zeros(1,length(i));

i=find(rkn<tol*max(rkn) | rkn<tol*ikn);
K(i)=sqrt(-1)*imag(K(i));

i=find(ikn<tol*max(ikn) | ikn<tol*rkn);
K(i)=real(K(i));
