% Script p9_3_13b.m; minimum time erection of an inverted pendulum
% using inverse dynamic optimization (q,v) as key state variables)
% with FMINCON; u in units of (M+m)g; ep=m/(m+M);    1/97, 3/29/02
%
ep=.5; umax=1; N=40;  
load ip_fg; p0=p;
lb=p0-.1*abs(p0); ub=p0+.1*abs(p0); optn=optimset('display','iter');
p=fmincon('ip_f',p0,[],[],[],[],lb,ub,'ip_c2',optn,ep,umax); 
[c,ceq,th,q,y,v,u]=ip_c2(p,ep,umax);
tf=p(2*N-1); t=tf*[0:N]/N; tu=tf*[.5:N-.5]/N;
%save c:\book_do\figures\ip_fg p
%
figure(1); clf; plot(t,th,'b',t,y,'r--',tu,u,'k'); grid; 
axis([0 5 -1.2 3.2]); xlabel('t*sqrt(g/l)'); hold on;
plot(tu,u,'.'); hold off; legend('\theta','x/l','f/mg',2);
%
figure(2); clf; a=plot(t,v,'b',t,q,'r--'); grid;
xlabel('t*sqrt(g/l)'); legend(a,'v','q'); 