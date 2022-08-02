% Script p5_4_06r.m; undamped oscillator using TLQHR; s=[y v]';
%                                                  2/93, 7/14/02
%
A=[0 1; -1 0]; B=[0 1]'; Q=zeros(2); N=[0 0]'; R=1; tf=pi;
x0=[1 0]'; Mf=eye(2); Sf=zeros(2); psi=[0 0]'; t1=.95*tf;
tol=1e-4; [x,u,t,t1b,K]=tlqhr(A,B,Q,N,R,tf,x0,Sf,Mf,psi,t1,tol);
t=t/(2*pi); t1b=t1b/(2*pi);
%
figure(1); clf; subplot(211), plot(t,x); grid; legend('y','v');
subplot(212), plot(t,u); grid; ylabel('a'); xlabel('t/2\pi');
%
figure(2); clf; plot(t1b,K); grid; legend('K_y','K_v',2);
xlabel('t/2\pi');
   

   