% Script p9_3_04c.m; min fuel path for DIP using DP solution 
% in form u=u(x,v,x0,v0); if start with u=-1, switch to u=0 
% when 2v reaches the value v0-1+sqrt(1-2v0-v0^2-4x0), then
% switch to u=1 when 2x=v^2;                   8/99, 3/31/02
%
figure(1); clf;
v0=0; N=500; dt=1/N; x0=[.025:.025:.25]; 
for i=1:10, x(1)=x0(i); v(1)=v0; u=-1;
 for k=1:N,
  if 2*v(k)<v0-1+sqrt(1-2*v0-v0^2-4*x0(i)), u=0; end 
  if 2*x(k)-v(k)^2<0, u=1; end
  v(k+1)=v(k)+u*dt; x(k+1)=x(k)+v(k)*dt+u*dt^2/2;
 end
%
figure(1); plot(2*x,v); hold on
end; axis([-.15 .6 -.6 .15]); grid; axis('square') 
%
clear x v x0
v0=.12; x0=[.03:.03:.12];
for i=1:4, x(1)=x0(i); v(1)=v0; u=-1;
 for k=1:N,
  if 2*v(k)<v0-1+sqrt(1-2*v0-v0^2-4*x0(i)), u=0; end 
  if 2*x(k)-v(k)^2<0, u=1; end
  v(k+1)=v(k)+u*dt; x(k+1)=x(k)+v(k)*dt+u*dt^2/2;
 end
%
figure(1); plot(2*x,v); hold on
end; plot(0,0,'ro'); hold off; ylabel('v/u_0t_f')
xlabel('2x/u_0t_f^2')
                   

