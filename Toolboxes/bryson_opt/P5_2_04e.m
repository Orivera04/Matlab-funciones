% Script p5_2_04e.m; first order system using analytical Riccati
% soln. and TLQSR for tf=2 and 20;                  8/97, 3/29/02
%
A=-1; B=1; Q=4; N=1; R=1; x0=3; Mf=1; Qf=30; psi=1; tol=1e-5;
tf1=[2 20]; for i=1:2, tf=tf1(i);
 [x,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol); nt=length(tk);
 un=ones(nt,1); T=tf*un-tk; Ab=A-N; Qb=Q-N^2; a=sqrt(Ab^2+Qb);
 at=atanh(a/(Qf-Ab)); S=Ab*un+a*un./tanh(a*T+at*un); K1=N*un+S;
 %
 figure(2*i-1); subplot(211),plot(t,x); grid; ylabel('x')
 subplot(212), plot(t,u); grid; xlabel('Time t'); ylabel('u')
 %
 figure(2*i); clf; subplot(211), semilogy(tk,K,tk,K1,'r.'); grid
 legend('K -Riccati','K - Analytical'); xlabel('Time t')
 axis([tf-1 tf 1 100]) 
end
