[f, p]=distload(-10, -30, 0.2);
af=[0 -40 .4 0; 0 25 1 0; 0 f 0.6+p 0];
[Force,Moment]=reaction(af,[0 0]);
x=0:.002:1;
s(1,:)=diagram(x,'point',Force(1,2),Force(1,3));
s(2,:)=diagram(x,'point',af(1,2),af(1,3));
s(3,:)=diagram(x,'distributed',[-10 -30],[0.6 0.8]);
s(4,:)=diagram(x,'point',af(2,2),af(2,3));
Shear=sum(s);
m(1,:)=diagram(x,'point',-Moment,0);
m(2,:)=diagramintegral(x,Shear);
Moment=sum(m);
E=matprop('structural steel','E','SI')*1e9; %Pascals
I=rectangl(0.02,0.05,'Ix');
[Di,Slope]=displace(x,Moment,['place','slope'],[0 0],E,I);
plotSMSD(x,Shear,Moment,Slope,Di)
