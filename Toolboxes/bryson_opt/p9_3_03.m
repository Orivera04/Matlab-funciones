% Script p9_3_03.m; min time to origin from (x,v) for double integrator
% w. damping: dot v=-v+a, dot x=v, |a| <= 1; phase plane plot;   8/1/98
%
v=[-2:.02:0];    un =ones(1,length(v));  x =-v -log(un-v);
v1=[-2:.02:.68]; un1=ones(1,length(v1)); x1=-v1-log(un1-v1)-.6*un1;
v2=[-2:.02:.84]; un2=ones(1,length(v2)); x2=-v2-log(un2-v2)-1.2*un2;
v3=[-2:.02:.92]; un3=ones(1,length(v3)); x3=-v3-log(un3-v3)-1.82*un3;
v4=[1.08:.02:2]; un4=ones(1,length(v4)); x4=-v4-log(v4-un4)-1.78*un4;
v5=[1.4:.02:2];; un5=ones(1,length(v5)); x5=-v5-log(v5-un5)-.02*un5;
%
figure(1); clf; plot(x,v,-x,-v,'b',0,0,'ro',[.31 2],[-1 -1],'b',...
   [-.31 -2],[1 1],'b',x1,v1,'b',x2,v2,'b',x3,v3,'b',-x1,-v1,'b',...
   -x2,-v2,'b',-x3,-v3,'b',x4,v4,'b',-x4,-v4,'b',x5,v5,'b',-x5,-v5,'b');
grid; axis([-2 2 -2 2]); xlabel('x'); ylabel('v'); 