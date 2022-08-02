function [f,th,s]=dgeo2(p,th0,thf,phf)
% Subroutine for p3_1_03 for use with FSOLVE; min distance between two
% points on a sphere;                                           6/4/98
%
N=length(p)-1; be=p(1:N); la(N+1)=p(N+1); dph=phf/N; s(1)=0; th(1)=th0;  
for i=1:N,
   b(i)=exp(dph*tan(be(i))); z(i)=b(i)*tan(th(i)/2+pi/4);
   th(i+1)=2*atan(z(i))-pi/2; sb=sin(be(i));
   if abs(sb)>.0001, s(i+1)=s(i)+(th(i+1)-th(i))/sb;
      else s(i+1)=s(i)+cos(th(i))*dph; end
end;  
for i=N:-1:1,
   a=th(i)/2+pi/4; ct=cos(a); st=sin(a); sb=sin(be(i)); cb=cos(be(i)); 
   zt=b(i)/(ct^2*(1+z(i)^2)); zb=2*z(i)*dph/(cb^2*(1+z(i)^2));
   if abs(sb)>.0001, la(i)=-1/sb+(la(i+1)+1/sb)*zt;
      f(i)=-cb*(th(i+1)-th(i))/sb^2+(la(i+1)+1/sb)*zb; 
   else la(i)=la(i+1)-st*dph; 
      f(i)=la(i+1)*cos(th(i))*dph+(sin(th(i))*dph)^2;
   end; 
end
f(N+1)=th(N+1)-thf;
