% Script p5_4_04.m; first order system using TLQH (flg=1) or 
% TLQHR (flg=2);                                8/97, 7/4/02
%
flg=1; 
A=-1; B=1; Q=4; N=1; R=1; tf=5; x0=3; Mf=1; psi=1; Sf=0; 
Ns=65; t1=.99*tf; tol=1e-5;
if flg==1
  [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns);
elseif flg==2
  [x,u,t,t1k,K]=tlqhr(A,B,Q,N,R,tf,x0,Sf,Mf,psi,t1,tol);
end
%
figure(1); subplot(211),plot(t,x); grid; ylabel('x')
subplot(212), plot(t,u); grid; xlabel('Time'); ylabel('u')
%
if flg==2, figure(2); clf; subplot(211), plot(t1k,K); grid 
axis([0 5 0 20]); ylabel('Gain K'); xlabel('Time'); end 
	
