% Script p9_3_11.m; min time control of pendulum w. bounded torque
% using MATLAB code FMINCON; q=[q0; p; 0]; (q0,th0) spec.;
% -1<=Q<=1;                                          4/98, 3/29/02
%
N=40; th0=pi/6; q0=0; tf0=1.4; un=ones(1,N-1); p=[0*un tf0];
lb=[-2*un 0]; ub=[2*un 6]; optn=optimset('display','iter');
p=fmincon('pend_f',p,[],[],[],[],lb,ub,'pend_c',optn,th0,q0,N);
[f,th,q,Q]=pend_f(p,th0,q0,N); c=pend_c(p,th0,q0,N); 
tf=p(N); t=tf*[0:N]/N; t1=tf*[.5:N-.5]/N;
%
figure(1); clf; subplot(211), plot(t,th,t1,Q,t,q,t,th,'.',...
  t1,Q,'.',t,q,'.'); axis([0 1.4 -1.2 1.2]); text(.85,.8,'Q') 
text(.65,.35,'\theta'); text(.38,-.35,'q'); grid 
xlabel('Time'); subplot(212), plot(th,q,th,q,'.'); grid 
axis([0 .8 -.8 0]); xlabel('\theta'); ylabel('q'); axis('square')
%
figure(2); clf; subplot(211), plot(t,th,t,th,'.'); grid 
ylabel('\theta'); subplot(212), plot(t,q,t,q,'.'); grid 
xlabel('t'); ylabel('q')
       
