% Script p5_2_05b.m; lateral intercept using TLQSR; 
%                                           5/98, 3/31/02
%
A=[0 1; 0 0]; B=[0 1]'; Q=zeros(2); N=zeros(2,1); R=1;
tf=1; s0=[0 1]'; Mf=eye(2); Qf=1e4; psi=[0 0]'; tol=1e-4;
[s,a,t,tk,K]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol); 
y1=s(:,1); v=s(:,2); 
%
figure(1); clf; subplot(211), plot(tk,K(:,1)); grid; 
ylabel('Ky'); subplot(212), semilogy(tk,K(:,2)); grid;
ylabel('Kv'); xlabel('Time'); axis([0 1 1 1e4])
%
figure(2); subplot(211), plot(t,y1); grid; ylabel('y/v_0t_f') 
subplot(212), plot(t,v,t,a/3,'--'); grid; xlabel('Time')
legend('v/v_0','at_f/(3v_0)',4)