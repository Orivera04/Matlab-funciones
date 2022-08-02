% Script p5_3_04.m; 1st order system using TDLQS (flg=1) or TDLQSR
% (flg=2);                                           8/97, 6/30/02
%
flg=2;
tf=2; A=-1; B=1; Q=4; N=1; R=1; x0=3; Mf=1; Qf=1e3; psi=1;
Ns=50; Ts=tf/Ns; [Ad,Bd,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts); 
t=tf*[0:1/Ns:1];
if flg==1
    [x,u]=tdlqs(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,Ns); 
elseif flg==2
    [x,u,K]=tdlqsr(Ad,Bd,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,Ns);
end
uh=[u u(:,Ns)];
%
figure(1); clf; subplot(211),plot(t,x); grid; ylabel('x')
subplot(212), zohplot(t,uh); grid; ylabel('u'); xlabel('t')

	