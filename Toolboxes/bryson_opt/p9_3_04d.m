% Script p9_3_04d.m; min fuel path for DIP using DP solution 
% in form u=u(x,v,t); switch to u=0 when predicted time-to-go
% to (0,0) with coast-bang = 1-t;               8/99, 3/31/02
%
figure(1); clf; N=1000; dt=1/N; v=zeros(1,N+1); x=v;
v0=0; x0=[.025:.025:.25]; 
for i=1:10, x(1)=x0(i); v(1)=v0; u=-1;
   for k=1:N,
    if v(k)<0 & k/N<=1+v(k)/2+x(k)/v(k); u=0; end  
    if v(k)<0 & 2*x(k)-v(k)^2<0, u=1; end
    v(k+1)=v(k)+u*dt; x(k+1)=x(k)+v(k)*dt+u*dt^2/2;
   end
   figure(1); plot(2*x,v); hold on;
end 
%
clear x0; v=zeros(1,N+1); x=v;
v0=.12; x0=[.03:.03:.21];
for i=1:7, x(1)=x0(i); v(1)=v0; u=-1;
   for k=1:N,
    if v(k)<0 & k/N<=1+v(k)/2+x(k)/v(k); u=0; end  
    if v(k)<0 & 2*x(k)-v(k)^2<0, u=1; end
    v(k+1)=v(k)+u*dt; x(k+1)=x(k)+v(k)*dt+u*dt^2/2;
   end
   figure(1); plot(2*x,v); hold on 
end; plot(0,0,'ro'); hold off; axis([-.15 .6 -.6 .15]); grid 
axis('square'); ylabel('v/u_0t_f'); xlabel('2x/u_0t_f^2')



