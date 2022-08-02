function [c,ceq,x,y]=dfrmt_c(p,xf,yf)
% Subroutine for Pb. 4.1.04;                    2/97, 3/29/02
%
N=length(p)-1; th=p(1:N); tf=p(N+1); x(1)=0; y(1)=0; dt=tf/N;
for i=1:N, s=sin(th(i)); ta=tan(th(i));  
 if th(i)==0, b(i)=dt;  else b(i)=(exp(dt*s)-1)/ta; end;
 x(i+1)=x(i)+(1+y(i))*b(i); y(i+1)=(b(i)*ta+1)*(1+y(i))-1;
end
ceq=[x(N+1)-xf y(N+1)-yf]; c=[];