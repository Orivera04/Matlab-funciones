% Script p5_3_02.m; disc. undamped oscillator with soft term. constr;
%                                                       4/97, 6/30/02
%
A=[0 1;-1 0]; B=[0 1]'; x0=[1 0]'; Qd=zeros(2); Nd=[0 0]'; Rd=1;
Mf=eye(2); Qf=1e4; tf=[1 10]*pi; Ns=[50 100]; psi=[0 0]';
for i=1:2, Ts=tf(i)/Ns(i); [Ad,Bd]=c2d(A,B,Ts);
 [x,u,K,uf]=tdlqsr(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,Ns(i));
 t=tf(i)*[0:1/Ns(i):1]; uh=[u u(Ns(i))];
 figure(i); clf; subplot(211), t=t/(2*pi); plot(t,x); grid 
 ylabel('y v'); subplot(212), zohplot(t,uh); grid; ylabel('u')
 xlabel('t/(2\pi)')
end 

