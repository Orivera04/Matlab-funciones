function [f,th,s]=dgeoc_f(be,th0,phf)
% Subroutine for p2_1_3a.m using FMINU; min distance to a meridian on a
% sphere; exact system eqns;                                    6/2/98
%
N=length(be); dph=phf/N; th(1)=th0; s(1)=0;
for i=1:N, z=tan(th(i)/2+pi/4)*exp(dph*tan(be(i)));
   th(i+1)=2*atan(z)-pi/2; si=sin(be(i));
   if abs(si)>.0001, s(i+1)=s(i)+(th(i+1)-th(i))/si;
      else s(i+1)=s(i)+cos(th(i))*dph; end
end
f=s(N+1);