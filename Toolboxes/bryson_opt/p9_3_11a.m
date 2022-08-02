% Script p9_3_11a.m; min time control of pendulum w. bounded
% torque in the (th,q) space using analytical solution;   9/98, 3/31/02
%
th=[0:.02:2]; q=-sqrt(2*th-th.^2); N=length(q); un=ones(1,N); 
al=pi*[13:2:193]/180; N1=length(al); un1=ones(1,N1); x=un1+3.5*cos(al);
y=-3.5*sin(al); al1=pi*[30:2:210]/180; x1=-un1-1.62*cos(al1);
y1=1.62*sin(al1);
%
figure(1); clf; plot(th,q,-th,-q,'b',0,0,'ro',th+2*un,q,'b',...
   -th-2*un,-q,'b',x,y,'b',-x,-y,'b',x1,y1,'b',-x1,-y1,'b'); 
grid; axis([-4 4 -4 4]); axis('square'); xlabel('\theta'); 
ylabel('q=d\theta/dt'); text(1.1,.6,'Q=-1'); text(-1.1,-.6,'Q=+1');
title('Pb. 9.3.11 - Min Time Control of a Pendulum w. Bounded Torque');