function [f,v,x,h,m,T]=rkt_f(p,N,hf)                                            
% Subroutine for Pb. 10.3.2; 		              8/95, 4/5/02
%      
rhoo=.0021; CdS=.47; gv=32.2; cf=208*gv; mf=500/gv; mo=2; 
lc=2*mf/(CdS*rhoo); cf=cf/sqrt(gv*lc); al=lc/30000; hf=hf/lc;  
%       
v=p(1:N+1); ga0=p(N+2); tf=p(N+3); dt=tf/N; 
vd=(v(2:N+1)-v(1:N))/dt; vb=(v(2:N+1)+v(1:N))/2;
d(1)=asinh(tan(ga0)); for i=1:N, d(i+1)=d(i)-dt/vb(i); end
ga=atan(sinh(d)); gb=(ga(2:N+1)+ga(1:N))/2;
h(1)=0; x(1)=0; for i=1:N,
  h(i+1)=h(i)+vb(i)*sin(gb(i))*dt;
  x(i+1)=x(i)+vb(i)*cos(gb(i))*dt; end
hb=(h(2:N+1)+h(1:N))/2; Db=exp(-al*hb).*vb.^2;
a=vd+sin(gb); b=ones(1,N)+dt*a/(2*cf); m(1)=mo*exp(-v(1)/cf);
for i=1:N, T(i)=(Db(i)+m(i)*a(i))/b(i); m(i+1)=m(i)-T(i)*dt/cf;
end; t=[0:N]/N; tb=[.5:1:N-.5]/N;
f=-x(N+1);			                        % Performance index



