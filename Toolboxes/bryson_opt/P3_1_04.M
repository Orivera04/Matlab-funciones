% Script p3_1_4.m; DVDP for max range with V=1+y & yf 
% specified (Fermat Pb.); uses FSOLVE with discrete EL
% eqns; set yf in 'dfermc';                11/96, 3/30/02
%
tf=2; p0=[[.8:-.16:-.8] -1]; N=length(p0)-1;
x=zeros(1,N+1); y=x; 
optn=optimset('Display','Iter','MaxIter',200);
p=zeros(1,N); p=fsolve('dfermc',p0,optn,tf);
%
x(1)=0; y(1)=0; dt=tf/N; th=p([1:N]);
for i=1:N,
 s=sin(th(i)); ta=tan(th(i));  
 if th(i)==0, b(i)=dt; else b(i)=(exp(dt*s)-1)/ta; end
 x(i+1)=x(i)+(1+y(i))*b(i); y(i+1)=(b(i)*ta+1)*(1+y(i))-1;
end
%	
figure(1); clf; plot(x,y,x,y,'b.'); grid; xlabel('x'); 
ylabel('y'); axis([0 2.5 0 1.5])
