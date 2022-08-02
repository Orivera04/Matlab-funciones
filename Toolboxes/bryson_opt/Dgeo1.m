function [f,th,s]=dgeo1(be,th0,phf)
% Subroutine for Pb. 2.1.3;                          6/98, 3/23/02
%
N=length(be); dph=phf/N; s(1)=0; th(1)=th0; la(N+1)=0; 
for i=1:N,
   b(i)=exp(dph*tan(be(i))); z(i)=b(i)*tan(th(i)/2+pi/4);
   th(i+1)=2*atan(z(i))-pi/2; sb=sin(be(i));
   if abs(sb)>.0001, s(i+1)=s(i)+(th(i+1)-th(i))/sin(be(i));
      else s(i+1)=s(i)+cos(th(i))*dph; end
end
for i=N:-1:1,
   ct=cos(th(i)/2+pi/4); sb=sin(be(i)); zt=b(i)/(ct^2*(1+z(i)^2));
   if abs(sb)>.0001, la(i)=-1/sb+(la(i+1)+1/sb)*zt;
   else la(i)=la(i+1); end 
   cb=cos(be(i)); zb=2*z(i)*dph/(cb^2*(1+z(i)^2));
   f(i)=-cb*(th(i+1)-th(i))+sb*(sb*la(i+1)+1)*zb;
end
	
	
