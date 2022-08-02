% Script p5_5_07.m; inverted pendulum using TDLQH (flg=1) or TDLQHR
% (flg=2); x=[th q]';                                    7/97, 7/25/02
%
flg=1; A=[0 1;1 0]; B=[0 1]'; Qd=zeros(2); Nd=[0 0]'; Rd=1; x0=[1 0]';
Mf=eye(2); Sf=zeros(2); psi=[0 0]'; tf=[3 15]; Ns=[50 100]; nf=3;
for i=1:2,
 Ts=tf(i)/Ns(i); t=tf(i)*[0:1/Ns(i):1]; [Ph,Ga]=c2d(A,B,Ts); 
 if flg==1, [x,u]=tdlqh(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Ns(i));
 elseif flg==2,  
 [x,u]=tdlqhr(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Ns(i),nf);
 end; uh=[u u(Ns(i))]; 
 figure(i); clf; subplot(211), plot(t,x); grid
 legend('\theta','\theta dot'); subplot(212), zohplot(t,uh);
 grid; xlabel('t'); ylabel('u'); xlabel('t')
end 

