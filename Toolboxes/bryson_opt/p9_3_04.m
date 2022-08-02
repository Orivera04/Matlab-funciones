% Script p9_3_04.m; min fuel to x=v=0 for double integrator plant
% with bounded control;                               8/98, 3/31/02
%
v=-[0:.01:1]; x=v.^2; un=ones(1,101); x1=-v.^2-2*v;
vt=[-1:.02:1]; xt=vt.^2/2-vt-un/2; xt1=-vt.^2/2-vt+un/2;
v2=[-.75:.05:.75]; N2=length(v2); un2=ones(1,N2); J=3/4; 
x2=-v2.^2/2-v2+un2/2-(J-1)^2*un2/2; 
v3=[-.5:.05:.5]; N3=length(v3); un3=ones(1,N3); J=1/2;
x3=-v3.^2/2-v3+un3/2-(J-1)^2*un3/2;
v4=[-.25:.05:.25]; N4=length(v4); un4=ones(1,N4); J=1/4;
x4=-v4.^2/2-v4+un4/2-(J-1)^2*un4/2;
%
figure(1); clf; plot(x,v,-x,-v,'b',0,0,'ro',xt,vt,'r--',...
   xt1,vt,'r--',x1,v,'b',-x1,-v,'b',x2,v2,'r--',-x2,-v2,'r--');
hold on; plot([-.92 -.55],[.75 .75],'r--',[.92 .55],[-.75 -.75],...
   'r--',x3,v3,'r--',-x3,-v3,'r--',[-.75 -.25],[.5 .5],'r--',...
   [.75 .25],[-.5 -.5],'r--',x4,v4,'r--',-x4,-v4,'r--',...
   [-.08 -.45],   [.25 .25],'r--',[.08 .45],[-.25 -.25],'r--');
hold off; grid
axis([-1 1 -1 1]); xlabel('2x/u_0t_f^2'); ylabel('v/u_0t_f') 
text(-.75,.7,'J=.75'); text(-.5,.45,'J=.5')
text(-.27,.2,'J=.25'); text(.05,.48,'J=1'); text(.42,-.35,'t_1=0')
text(.25,.65,'Time Required > t_f')
text(-.55,-.75,'Time Required > t_f')