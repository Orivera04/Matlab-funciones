% Script p9_3_10.m; min time control of inv. pendulum w. bounded torque
% using MATLAB code FMINCON; q=[q0; p; 0]; (q0,th0) spec.;
% A*p<b, J=f'*p; -1<=Q<=1; th0=pi/6, q0=0;                4/98, 3/29/02
%
N=40; th0=1.8; q0=-1; tf0=3; un=ones(1,N-1); p=[-.1*un tf0]; ub=[un 3];
lb=[-un 0]; optn=optimset('display','iter');
p=fmincon('invp_f1',p,[],[],[],[],lb,ub,'invp_c',optn,th0,q0,N);
[f,th,q,Q]=invp_f1(p,th0,q0,N); c=invp_c(p,th0,q0,N);
tf=p(N); t=tf*[0:N]/N; t1=tf*[.5:N-.5]/N;
%
figure(1); clf; subplot(211), plot(t,th,t1,Q,t,q); grid;
%axis([0 1.8 -1.2 1.2]); 
hold on; plot(t,th,'.',t1,Q,'.',t,q,'.');
hold off; text(1.5,.8,'Q'); text(.65,.25,'\theta'); 
text(.42,-.35,'q'); xlabel('Time'); subplot(212),
plot(th,q,th,q,'.'); grid; axis([0 2 -2 0]); xlabel('\theta');
ylabel('q'); axis('square');
%
figure(2); clf; subplot(211), plot(t,th,t,th,'.'); grid;
ylabel('\theta'); xlabel('t'); subplot(212),
plot(t,q,t,q,'.'); grid; xlabel('t'); ylabel('q');
       
