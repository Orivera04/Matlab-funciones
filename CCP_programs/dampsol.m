function y=dampsol(t,c)
% Solution to damped mass-spring DE:
%     D2y + (c/m)*Dy + (K/m)*y = 0
%       with y(0)=y0, DYy(0)=0.

global K m y0

efact=-0.5*(c/m);
prerad=efact^2-K/m;

if prerad<-1.0e-10
  rad=sqrt(-prerad);
  y=y0*exp(efact*t).*( cos(rad*t)-(efact/rad)*sin(rad*t) );
elseif abs(prerad)<1.0d10
  y=y0*(1-efact*t).*exp(efact*t);
else
  rad=sqrt(prerad);
  lam1=efact+rad;
  lam2=efact-rad;
  y=y0/(lam2-lam1)*( lam2*exp(lam1*t)-lam1*exp(lam2*t) );
end