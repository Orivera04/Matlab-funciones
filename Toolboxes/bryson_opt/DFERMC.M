function f=dfermc(p,tf)
% Subroutine for Pbs. 3.1.4 & 3.2.4; DVDP for max range with V=1+y &
% yf specified;                                        12/96, 6/8/98
yf=0; N=length(p)-1; x(1)=0; y(1)=0; dt=tf/N; th=p([1:N]);
x=zeros(1,N+1); y=x; ly=x; ly(N+1)=p(N+1);   
for i=1:N, ta(i)=tan(th(i)); s(i)=sin(th(i)); 
 if th(i)==0, b(i)=dt; else b(i)=(exp(dt*s(i))-1)/ta(i); end;
 x(i+1)=x(i)+(1+y(i))*b(i); y(i+1)=(b(i)*ta(i)+1)*(1+y(i))-1;
end;
for i=N:-1:1, c=cos(th(i)); ly(i)=b(i)+ly(i+1)*(b(i)*ta(i)+1);
 if th(i)==0, Hu(i)=ly(i+1)*dt;
 else Hu(i)=dt*(b(i)*ta(i)+1)*c^2/s(i)-b(i)*ta(i)/s(i)^2 ...
    +ly(i+1)*(b(i)*ta(i)+1)*dt*c;
 end;
end;
f=[Hu y(N+1)-yf];
	        
	
	
