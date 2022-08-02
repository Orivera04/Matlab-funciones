% Script p5_5_06.m; undamped oscillator w. TDLQH (flg=1) or TDLQHR
% (flg=2); s=[y v]';                                       7/97, 7/25/02
%
flg=1; A=[0 1; -1 0]; B=[0 1]'; Qd=zeros(2); Nd=[0 0]'; Rd=1; x0=[1 0]';
Mf=eye(2); Sf=zeros(2); psi=[0 0]';	tf=[2 10]*pi; Ns=[50 100]; nf=3;
for i=1:2, Ts=tf(i)/Ns(i);
 [Ph,Ga]=c2d(A,B,Ts); t=tf(i)*[0:1/Ns(i):1]; 
 if flg==1, [x,u]=tdlqh(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Ns(i));
 elseif flg==2, [x,u]=tdlqhr(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Ns(i),nf);
 end
uh=[u u(Ns(i))];
 figure(i); clf; subplot(211), t=t/(2*pi); plot(t,x); grid
 ylabel('y and v'); subplot(212), zohplot(t,uh); grid; ylabel('a')
 xlabel('t/tf')
end

