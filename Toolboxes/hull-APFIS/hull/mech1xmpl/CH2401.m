MomentOnEnd=30;
[DLForce DLPlacement]=distload(-30,-30,3);
af(1,:)=[0 -10 0 0];
af(2,:)=[0 DLForce 10+DLPlacement 0];
Unknowns=[DR(90) 5 0; DR(90) 19 0;0 5 0];
Reactions=threevector(af,Unknowns,-MomentOnEnd);
x=0:0.1:20;
s(1,:)=diagram(x,'point',af(1,2),af(1,3));
s(2,:)=diagram(x,'point',Reactions(1,2),Reactions(1,3));
s(3,:)=diagram(x,'distributed',[-30 -30],[10 13]);
s(4,:)=diagram(x,'point',Reactions(2,2),Reactions(2,3));
Shear=sum(s);
m(1,:)=diagram(x,'point',MomentOnEnd,0);
m(2,:)=diagramintegral(x,Shear);
Moment=sum(m);
plotSMD(x,Shear,Moment)
interpolate (x,Shear,12.33)
MaxShear=max(abs(Shear))
MaxMoment=max(abs(Moment))
XatMaxMoment=x(find(abs(Moment)==max(abs(Moment))))
XatMaxShear=x(find(abs(Shear)==max(abs(Shear))));
