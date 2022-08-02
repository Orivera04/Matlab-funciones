% Script p9_3_10a.m; min time control of inv. pendulum w. bounded
% torque in the (th,q) space using analytical solution; 9/98, 3/31/02
%
q=-[0:.02:2]; N=length(q); un=ones(1,N); th=-un+sqrt(un+q.^2);
q1=[-2:.02:.65]; N1=length(q1); un1=ones(1,N1); 
th1=-un1+sqrt(.25*un1+q1.^2);
th2=[.31:.05:2]; N2=length(th2); un2=ones(1,N2);
q2=-sqrt(.25*un2+(-un2+th2).^2);
%
figure(1); clf; plot(th,q,-th,-q,'b'); grid; axis([-2 2 -2 2]);
axis('square'); hold on; plot([-1 2],[2 -1],'b',[1 -2],[-2 1],'b',...
   0,0,'ro',[.25 1],[-.75 0],'b',[-1 -.25],[0 .75],'b',th1,q1,'b',...
   -th1,-q1,'b',th2,q2,'b',-th2,-q2,'b'); 
hold off; xlabel('\theta'); ylabel('q=d\theta/dt');
text(.6,1.2,'Uncontrollable'); text(-1.2,-1.2,'Uncontrollable');
text(1.1,-1.2,'Q=-1'); text(-1.4,1.2,'Q=+1');
title('Pb. 9.3.10 - Min Time Control of Inverted Pendulum w. Bounded Torque');