% Script f05_04.m; lateral intercept w. TLQSR;  8/97, 4/3/02
%
A=[0 1; 0 0]; B=[0 1]'; Q=zeros(2); N=zeros(2,1); R=1;
tf=1; s0=[0 1]'; Mf=[1 0]; Qf=3e4; psi=0; tol=1e-4;
[s,a,t,tk,K]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);
y1=s(:,1); v=s(:,2); 
%
figure(1); clf; subplot(211), plot(tk,K(:,1)); grid
ylabel('K_y'); axis([0 1 0 800]); subplot(212),
plot(tk,K(:,2)); grid; ylabel('K_v'); xlabel('Time');
axis([0 1 0 40]) 
%print -deps2 \book_do\figures\f05_04
%
figure(2); subplot(211), plot(t,y1); grid; 
ylabel('y/v_0t_f'); subplot(212), plot(t,v,t,a/3); 
grid; xlabel('Time'); ylabel('v/v_0 & at_f/(3v_0)')