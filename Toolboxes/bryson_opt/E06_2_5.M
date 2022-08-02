% Script e06_2_5.m; Navion lateral motions (MIMO); x=[v r p phi]'; 
% u=[da dr]'; xdot=Ax+Bu; J=int{eta[(5ay)^2+(phi/10)^2]+da^2+dr^2}dt;
% units ft, sec, crad; SRL vs. eta;                     7/92, 6/24/02
%
A=[-.254 -1.76 0 .322; 2.55 -.76 -.35 0; -9.08 2.19 -8.4 0; 0 0 1 0];
B=[0 .1246;-.222 -4.60; 29.0 2.55;0 0]; C=[-.254 0 0 0; 0 0 0 1];
D=[0 .1246; 0 0]; Q=[5^2 0;0 1/10^2]; R=eye(2);
eta=[1e-8 .1 .3 1 3 10 30 60 100:50:250 300:100:1000 1e8]';
N=length(eta); for i=1:N, Qa=eta(i)*Q; k=lqry(A,B,C,D,Qa,R);
   ev(:,i)=eig(A-B*k); end; z=ev(:,N); ev=ev(:,[1:N-1]);
%
figure(1); clf; plot(real(ev),imag(ev),'x',real(z),imag(z),'o'); grid
axis([-9 0 0 .75*9]); xlabel('Real(s) (rad/sec)') 
ylabel('Imag(s) (rad/sec)'); text(-4,.6,'TZ')
text(-3.5,.6,'Refl.TZ'); text(-2.1,.6,'Spiral Mode') 
text(-7.5,.6,'Roll Mode'); text(-5.5,2.5,'Dutch Roll Mode')
text(-2,2.4,'1'); text(-7.5,5.5,'\eta=1000'); text(-1.2,2.6,'.1')
text(-3,1.4,'10'); text(-4.5,1.2,'100'); text(-.5,2.6,'0')
%
eta=100; Qa=eta*Q; k=lqry(A,B,C,D,Qa,R); C1=[1 0 0 0; 0 1 0 0];
D1=zeros(2); yc=[0 1]'; t=3*[0:.01:1]';
[y,y1,u]=stepcmd(A,B,C,D,k,yc,C1,D1,t);
%
figure(2); clf; subplot(211), plot(t,y(:,2),t,y1(:,1),'-',t,y1(:,2),'-');
grid; axis([0 3 -.2 1]); text(1.05,.65,'\phi (crad)') 
text(1.05,.25,'r (crad/sec)'); text(2.1,.08,'v (ft/sec)')
subplot(212), plot(t,10*y(:,1),t,u(:,1),'-',t,u(:,2),'-'); grid
axis([0 3 -.2 .4]); text(.7,.25,'\delta a (crad)'); xlabel('Time (sec)')
text(2.1,-.13,'\delta r (crad)'); text(.3,.05,'10*a_y (ft/sec/sec)') 