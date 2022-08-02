% Script p5_4_04a.m; 1st order system - analytic soln;   8/97, 7/4/02
%
tf=5; a=-1; q=4; n=1; x0=3; xf=1; ab=a-n; qb=q-n^2; a1=sqrt(ab^2+qb);
ch=cosh(a1*tf); sh=sinh(a1*tf); b=ab/a1; ph1=ch+b*sh; ph2=-sh/a1;
ph3=-qb*sh/a1; ph4=ch-b*sh; la0=(-ph2)\((ph1)*x0-xf); t=tf*[0:.01:1];
ch=cosh(a1*t); sh=sinh(a1*t); ph1=ch+b*sh; ph2=-sh/a1; ph3=-qb*sh/a1;
ph4=ch-b*sh; x=ph1*x0+ph2*la0; la=ph3*x0+ph4*la0; u=-n*x-la;
%
figure(1); clf; subplot(211),plot(t,x); grid; ylabel('x') 
subplot(212), plot(t,u); grid; ylabel('u'); xlabel('t')

