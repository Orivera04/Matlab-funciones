% Script p5_4_01.m; 1st order system - analytic and transition
% matrix solns;                                   5/98, 7/3/02
%
flg=2;
if flg==1, tf=2; elseif flg==2, tf=20; end
A=-1; x0=3; Qf=1e3; xf=1; a1=abs(A); Ns=65;
%
% Analytical solution:
t=tf*[0:1/Ns:1]; T=tf*ones(1,Ns+1)-t; 
xa=(xf*sinh(a1*t)+x0*sinh(a1*T))/sinh(a1*tf);
ua=-A*xa+a1*(xf*cosh(a1*t)-x0*cosh(a1*T))/sinh(a1*tf);
%
% Analytical transition matrix solution:
ch=cosh(a1*tf); sh=sinh(a1*tf); b=A/a1; ph1=ch+b*sh;
ph2=-sh/a1; ph4=ch-b*sh; la0=(ph4-Qf*ph2)\((Qf*ph1)*x0-Qf*xf); 
ch=cosh(a1*t); sh=sinh(a1*t); ph1=ch+b*sh; ph2=-sh/a1;
ph4=ch-b*sh; x=ph1*x0+ph2*la0; u=-ph4*la0; 
%
figure(1); clf; subplot(211), plot(t,x,'b',t,xa,'r.'); grid
legend('Trans. Matrix','Analytical'); axis([0 tf 0 3])
subplot(212), plot(t,u,'b',t,ua,'r.'); axis([0 tf -5 4]) 
grid; legend('Trans. Matrix','Analytical',2); xlabel('t')
	