% Script p5_2_08e.m; triple integrator plant using TLQSR;
% s=[y v a]';	                              5/98, 3/31/02
%
tf=3.915; A=[0 1 0; 0 0 1; 0 0 0]; B=[0 0 1]'; Q=zeros(3);
R=1; N=zeros(3,1); s0=[-1 0 0]'; Mf=eye(3); psi=zeros(3,1);
sa=1e2; sv=sa; sy=sa; Qf=diag([sy sv sa]); tol=1e-4;
[x,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol);  
y=x(:,1); v=x(:,2); a=x(:,3); t=t/tf;
%
figure(1); clf; subplot(211), plot(t,y,'b',t,v,'r--',t,...
    a,'g-.'); grid; legend('y','v','a',4); subplot(212),
plot(t,u,'b'); grid; ylabel('u'); xlabel('t/t_f')
%
figure(2); clf; plot(tk/tf,K); grid; axis([0 1 0 20]);
legend('K_y','K_v','K_a'); xlabel('t/t_f')