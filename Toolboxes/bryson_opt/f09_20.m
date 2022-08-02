% Script f09_20.m; min time pick-and-place motion of two-link robot
% arm using switch times as parameters; links of length L and mass m,
% tip mass=mu*m, (ue,us)=(shoulder,elbow) torques in units of max 
% torque=Qmax; time in units of tc=sqrt(m*L^2/Qmax), (oms,ome)=angular
% velocities of (shoulder,elbow) links in 1/tc, D=tip distance traveled
% in units of L (Dmax=4), tf in units of tc; uses symmetry about tf/2;
%                                                         4/98, 3/24/02
%
D=3.9; mu=1; t1=1.13; ths0=-.1; the0=-.2; tf=2.9; p=[t1 ths0 the0 tf]';
lb=[1 -.2 -.4 2.8]; ub=[1.4 0 3.0]; optn=optimset('display','iter');
p=fmincon('robo1_f',p,[],[],[],[],lb,ub,'robo1_c',optn,mu,D);
[f,t,s]=robo1_f(p,mu,D);
ti=(tf/2)*[0:1/20:1]; si=interp1(t,s,ti);      % Equal time intervals
oms=si(:,1); ome=si(:,2); ths=si(:,3); the=si(:,4); n=length(ti);
for i=1:n, oms1(i)=oms(n+1-i); ome1(i)=ome(n+1-i); 
   ths1(i)=-ths(n+1-i)-pi; the1(i)=-the(n+1-i)+2*pi; end
oms=[oms' oms1]; ome=[ome' ome1]; ths=[ths' ths1]; the=[the' the1];
te=[ti ti+(tf/2)*ones(1,n)]'; t1=p(1)/tf;
xe=cos(ths); ye=sin(ths); xt=xe+cos(the+ths); yt=ye+sin(the+ths);
%
figure(1); clf; subplot(211), plot([0 .5],[1 1],[.5 .5],[1 -1],...
   [.5 1],[-1 -1]); grid; axis([0 1 -1.2 1.2]); ylabel('Q_e'); 
subplot(212), plot([0 t1],[-1 -1],[t1 t1],[-1 1],[t1 .5],[1 1],...
   [.5 .5],[1 -1],[.5 1-t1],[-1 -1],[1-t1 1-t1],[-1 1],...
   [1-t1 1],[1 1]); grid; axis([0 1 -1.2 1.2]); ylabel('Q_s');
xlabel('t/tf');
%print -deps2 \book_do\figures\f09_20
%
figure(2); clf; e=180/pi; subplot(211), plot(te/tf,e*the); grid;
ylabel('\theta_e (deg)'); subplot(212), plot(te/tf,e*ths); grid; 
ylabel('\theta_s (deg)'); xlabel('t/tf')
%
figure(3); clf; subplot(211), plot(te/tf,ome-oms); grid;
ylabel('\omega_e-\omega_s'); subplot(212), plot(te/tf,oms); grid;
ylabel('\omega_s'); xlabel('t/tf');
%
xe=cos(ths); ye=sin(ths); xt=xe+cos(the+ths); yt=ye+sin(the+ths);
figure(4); clf;  
for i=1:length(te), 
 x1=[0 xe(i)]; y1=[0 ye(i)]; x2=[xe(i) xt(i)]; y2=[ye(i) yt(i)];
 plot(x1,y1,'b',x2,y2,'b',xt(i),yt(i),'ro'); axis([-2 2 -3 1]);
 axis('square'); axis off; pause(.1); hold on;
end; hold off; 
%print -deps2 \book_do\figures\f09_21
        