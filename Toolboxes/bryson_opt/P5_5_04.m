% Script p5_5_04.m; 1st order system using TDLQH (flg=1) or TDLQHR
% (flg=2);                                              8/97, 7/25/02
%
flg=2; tf=2; A=-1; B=1; Q=4; N=1; R=1; x0=3; Mf=1; psi=1; Ns=50;
Ts=tf/Ns; Sf=0; [Ad,Bd,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts); t=tf*[0:1/Ns:1];
if flg==1, [x,u]=tdlqh(Ad,Bd,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Ns); 
elseif flg==2, nf=3;
   [x,u,K,Kf]=tdlqhr(Ad,Bd,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,Ns,nf);
end; uh=[u u(Ns)];
%
figure(1); clf; subplot(211),plot(t,x); grid; ylabel('x')
axis([0 tf 0 3]); subplot(212), zohplot(t,uh); grid; ylabel('u')
xlabel('t')
	                
                
