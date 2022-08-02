% Script f06_06.m; Navion lateral motions (MIMO); x=[v r p phi]';
% u=[da dr]'; xdot=Ax+Bu; J=int{eta[(5*ay)^2+(phi/10)^2]+ 
% da^2+dr^2}dt; units ft, sec, crad; response to ayc=0, phic=1;
%                                                    7/92  4/4/02
%
A=[-.254 -1.76 0 .322; 2.55 -.76 -.35 0; -9.08 2.19 -8.4 0; 0 ...
    0 1 0]; B=[0 .1246; -.222 -4.60; 29.0 2.55; 0 0];
C=[-.254 0 0 0; 0 0 0 1]; D=[0 .1246; 0 0]; Q=[5^2 0;0 1/10^2];
R=eye(2); eta=100; Qa=eta*Q;  
C1=[1 0 0 0; 0 1 0 0]; D1=zeros(2); yc=[0 1]'; t=3*[0:.01:1]';
[y,u,x]=stepcmd(A,B,C,D,Qa,R,yc,t); y1=x*C1'+u*D1';

figure(1); clf; subplot(211), plot(t,y(:,2),t,y1(:,1),'-',t,...
    y1(:,2),'-'); grid; axis([0 3 -.2 1]) 
text(1.05,.65,'phi (crad)'); text(1.05,.25,'r (crad/sec)')
text(2.1,.08,'v (ft/sec)'); subplot(212), plot(t,10*y(:,1),...
    t,u(:,1),'-',t,u(:,2),'-'); grid; axis([0 3 -.2 .4]) 
text(.7,.25,'da (crad)'); text(2.1,-.13,'dr (crad)')
text(.3,.05,'10*ay (ft/sec/sec)'); xlabel('Time (sec)')
%print -deps2 f08_06
