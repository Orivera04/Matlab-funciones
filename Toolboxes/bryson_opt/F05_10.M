% Script f05_10.m; cart with inv. pendulum using TLQS; (M,m)=
% (cart,pendulum) mass, l=pendulum length, u=force on cart, 
% y=displ. of cart, th=angle pendulum; x=[y v th q]'; y in l, 
% t in sqrt[Ml/(M+m)g]/2*pi, u in (M+m)g, ep=m/(m+M); FAILS 
% for tf > 18;                                  2/95, 4/3/02
%
flg=1;                                   % Choose flg=1 or flg=2
if flg==1, tf=6; Ns=20; elseif flg==2, tf=15; Ns=60; end
ep=.5; A=[0 1 0 0; 0 0 -ep 0; 0 0 0 1; 0 0 1 0]; B=[0 1 0 -1]'; 
Q=zeros(4); N=zeros(4,1); R=1; x0=[0 0 0 0]'; Mf=eye(4); Qf=1e6;
psi=[1 0 0 0]';
[x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns); 
xc=x(1,:); th=x(3,:); xt=xc+sin(th); yt=cos(th); 
%
figure(1); subplot(211), plot(t,xc); grid; ylabel('y'); 
subplot(212), plot(t,u,t,2*th,'-'); grid; xlabel('Time');
ylabel('2 \theta & u'); pause(1);
%print -deps2 \book_do\figures\f05_09
%
% STROBOSCOPIC MOVIE of the motion:
figure(2); clf; for i=1:length(t), 
   plot(xc(i),0,'s',xt(i),yt(i),'ro',[xc(i) xt(i)],[0 yt(i)],'b');
   axis([-.5 1.5 -.5 1.5]); axis('square'); axis off; 
   plot([0 1],[0 0],'r'); hold on; pause(.1);  
end;
%print -deps2 \book_do\figures\f05_10
	
