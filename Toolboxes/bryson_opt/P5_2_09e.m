% Script p5_2_09e.m; change in position of cart with a pendulum
% using TLQS; s=[y v th q]';                      8/97, 3/31/02
%
flg=1;
if flg==1, tf=pi*2; Ns=20; elseif flg==2, tf=pi*10; Ns=60; end
ep=.5; A=[0 1 0 0; 0 0 ep 0; 0 0 0 1; 0 0 -1 0]; B=[0 1 0 -1]';
Q=zeros(4); N=zeros(4,1); R=1; x0=[0 0 0 0]'; Mf=eye(4);
Qf=3e4; R=1; psi=[1 0 0 0]'; 
[x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns); t=t/tf;
xc=x(1,:); th=x(3,:); xt=xc+sin(th); yt=-cos(th); 
%
figure(1); clf; subplot(211), plot(t,xc); grid
ylabel('Cart Position y/l')
subplot(212), plot(t,th,t,u); grid; pause(2)
xlabel('Time'); ylabel('Force u & \theta')
%
% MOVIE of the motion  
figure(2); clf; for i=1:length(t), 
   plot(xc(i),0,'s',xt(i),yt(i),'ro',[xc(i) xt(i)],...
      [0 yt(i)],'b',[0 1],[0 0],'r'); axis([-.3 1.3 -1.3 .3]);
   axis('square'); axis off; pause(.01); hold on 
end 
