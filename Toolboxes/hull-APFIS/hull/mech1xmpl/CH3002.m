x=0:0.01:1;
s(1,:)=diagram(x,'point',12.2,0);
s(2,:)=diagram(x,'distributed',[-45 -45],[0.1 0.7]);
s(3,:)=diagram(x,'point',14.8,1);
Shear=sum(s);
m(1,:)=diagram(x,'point',4,0.8);
m(2,:)=diagramintegral(x,Shear);
Moment=sum(m);
E=210e9; %Pascals
I=17e-6; %meters^4
Displacement=displace(x,Moment,['place','place'],[0 1],E,I);
plotSMD(x,Shear,Moment,Displacement);
disp(['The max deflection is ' num2str(max(abs(Displacement)))])
