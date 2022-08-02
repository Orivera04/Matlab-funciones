% Script p1_3_07e; max velocity of sailboat vs. heading angle psi;
% y=[V Wr alpha theta] using FMINCON;              10/96, 3/22/02
%
ps1=[5:5:175]*pi/180; n=length(ps1); y=zeros(n+1,4); 
optn=optimset('MaxIter',100); lb=zeros(1,4); ub=[2 3 pi/2 pi/2];
y(1,:)=[.5 .5 pi/2 pi/2];                          
for i=2:n+1, ps=ps1(i-1); 
 y(i,:)=fmincon('slbt_f1',y(i-1,:),[],[],[],[],lb,ub,'slbt_c1',optn,ps);
end
ps1=[0 ps1 pi]; V=[y(:,1);0]; Wr=[y(:,2);1]; al=[y(:,3);0]; 
th=[y(:,4);0]; Vm=.593; psm=73.3*pi/180; cm=cos(psm); sm=sin(psm);
%
figure(1); clf; plot(V.*sin(ps1'),-V.*cos(ps1')); grid; axis('square') 
axis([-.7 .7 -1 .4 ]); hold on; plot(-V.*sin(ps1'),-V.*cos(ps1'));
plot(0,0,'o',0,-1,'o',Vm*sm,-Vm*cm,'o',[0 Vm*sm],[-1 -Vm*cm],'r--');
plot([0 Vm*sm],[ 0 -Vm*cm],'r--',[0 0],[-1 0],'r--'); text(.42,-.08,'V')
hold off; text(-.15,-.7,'W'); text(.3,-.7,'W_R')
