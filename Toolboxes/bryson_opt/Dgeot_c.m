function [c,ceq,th,ph]=dgeot_c(p,th0,thf,phf)                              
% Subroutine for p4_2_03a;                     6/98, 3/29/02
%
c=pi/180; N=length(p)-1; be=p([1:N]); tf=p(N+1); dt=tf/N;
th(1)=th0; ph(1)=0;
for i=1:N
   c=cos(be(i)); s=sin(be(i)); th(i+1)=th(i)+dt*s;
   if abs(s)>.001,
      ph(i+1)=ph(i)+(c/s)*log(tan((th(i+1)/2+pi/4))/(tan(th(i)/2+pi/4)));
   else ph(i+1)=ph(i)+dt/cos(th(i));
   end
end
ceq(1)=th(N+1)-thf; ceq(2)=ph(N+1)-phf; c=[];
