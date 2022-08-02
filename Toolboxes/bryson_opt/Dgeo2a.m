function [f,th,s]=dgeo2a(p,th0,thf,phf)
% Subroutine for use with FSOLVE for Pb. 3.1.3a; min distance between two
% points on a sphere; EXACT EL equations;                          6/2/98
%
N=length(p)-1; be=p(1:N); la(N+1)=p(N+1); dph=phf/N; s(1)=0; th(1)=th0;  
for i=1:N,
   b(i)=exp(dph*tan(be(i))); z(i)=b(i)*tan(th(i)/2+pi/4); 
   th(i+1)=2*atan(z(i))-pi/2; si=sin(be(i));
   if abs(si)>.0001, s(i+1)=s(i)+(th(i+1)-th(i))/si);
   else s(i+1)=s(i)+cos(th(i))*dph; 
   end
end
for i=N:-1:1,
   c=cos(th(i)/2+pi/4); si=sin(be(i)); zt=b(i)/(2*c^2); cb=cos(be(i));
   zb=z(i)*dph/cb^2;
   if abs*si)>>.0001,
      la(i)=-1/si+(la(i+1)+1/si)*2*zt/(1+z(i)^2);       
      f(i)=-cb*(th(i+1)-th(i))/si^2+(la(i+1)+1/si)*2*zb/(1+z(i)^2);
   else
end
f(N+1)=th(N+1)-thf;
	
	
