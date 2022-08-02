% Script p5_2_04c.m; 1st order system - analytic and TM solutions
% tf=2 and tf=20;                                     7/97, 3/29/02
%
A=-1; Q=4; N=1; x0=3; xf=1; Qf=30; Ab=A-N; Qb=Q-N^2; 
a=sqrt(Ab^2+Qb); tf1=[2 20];
for i=1:2, tf=tf1(i);
 % Analytical solution:
 t=tf*[0:.01:1]; T=tf*ones(1,101)-t; cf=cosh(a*tf); sf=sinh(a*tf);
 ct=cosh(a*t); st=sinh(a*t); sT=sinh(a*T); cT=cosh(a*T); c2=x0/sf;
 c1=(xf+a*c2/Qf)/(sf+(a*cf-Ab*sf)/Qf); xa=c1*st+c2*sT; 
 ua=-A*xa+a*(c1*ct-c2*cT); 
  % Transition matrix solution:
 b=Ab/a; ph1=cf+b*sf; ph2=-sf/a; ph3=-Qb*sf/a; ph4=cf-b*sf; 
 la0=(ph4-Qf*ph2)\((Qf*ph1-ph3)*x0-Qf*xf); t1=tf*[0:.05:1]; 
 ch=cosh(a*t1); sh=sinh(a*t1); ph1=ch+b*sh; ph2=-sh/a; ph3=-Qb*sh/a;
 ph4=ch-b*sh; x=ph1*x0+ph2*la0; la=ph3*x0+ph4*la0; u=-N*x-la;
 %
 figure(i); clf; subplot(211), plot(t,xa,'b',t1,x,'r.'); grid
 legend('Analytical','Trans. Matrix'); axis([0 tf 0 3])
 subplot(212), plot(t,ua,'b',t1,u,'r.'); grid; axis([0 tf -5 4]) 
 xlabel('t')
end
	