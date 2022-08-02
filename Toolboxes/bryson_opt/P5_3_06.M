% Script p5_3_06.m; undamped oscillator with TDLQS (flg=1) or TDLQSR
% (flg=2);                                             4/97, 6/30/02
%
flg=1; A=[0 1;-1 0]; B=[0 1]'; x0=[1 0]'; Qd=zeros(2); Nd=[0 0]';
Rd=1; Mf=eye(2); Qf=3e4; tf=[1 10]*pi; N=[50 100]; psi=[0 0]';
for i=1:2, Ts=tf(i)/N(i); [Ph,Ga]=c2d(A,B,Ts);
 if flg==1
     [x,u]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N(i));
 elseif flg==2
     [x,u]=tdlqsr(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,N(i));
 end
 t=tf(i)*[0:1/N(i):1]; uh=[u u(N(i))]; figure(i); clf;
 subplot(211), t=t/(2*pi); plot(t,x); grid; ylabel('y v')
 subplot(212), zohplot(t,uh); grid; ylabel('u'); xlabel('t/(2\pi)')
end 

