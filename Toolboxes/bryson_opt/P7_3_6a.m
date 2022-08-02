 % Script p7_3_6a.m; TDP for min tf rendezvous at origin;
 % optimal paths in (V^2/2ar, gamma) space; 1/97, 7/17/02
 %
c=pi/180; thb1=c*[50 70 80 85 87 88 89]; N=5001; 
t=[0:.1:500]; un=ones(1,N);
for i=1:7,
 thb0=thb1(i); b=atan(un*tan(thb0)-t);   
 u=un*asinh(tan(thb0))-asinh(tan(b));
 v=un*sec(thb0)-sec(b); x=v-tan(b).*u;
 y=(.5)*(sec(thb0).*t-tan(b).*v-u);
 V=sqrt(u.^2+v.^2); r=sqrt(x.^2+y.^2);
 Vn=V./sqrt(2*r); ga=atan2(u.*y-v.*x,u.*x+v.*y);
 figure(1); hold on; plot(ga/c,Vn); 
 figure(2); hold on; plot(ga/c,Vn);
end
%
figure(1); hold off; grid 
text(2,1.65,'\beta=180'); text(30,1.65,'150')
text(58,1.65,'120'); text(87,1.65,'90')
text(118,1.65,'60'); text(150,1.65,'30')
text(170,1.65,'0')
text(90,1.35,'\theta_f=89'); text(85,1.06,'88')
text(78,.9,'87'); text(68,.75,'85')
text(51,.64,'80'); text(41,.7,'70')
text(28,.83,'50')
%
figure(2); hold off; grid 
text(88,1.45,'\theta_f=89'); text(82,1.06,'88')
text(78,.9,'87'); text(68,.75,'85')
text(51,.64,'80'); text(41,.7,'70')
text(28,.83,'50')
text(8,1.5,'aT/V=2.0'); text(110,1.65,'2.5')
text(145,1,'3.0'); text(150,.7,'3.5')
text(150,.58,'4.0'); text(150,.35,'6.0')
text(150,.24,'8.0'); text(155,.17,'10.0')
text(150,.08,'12.0'); text(1,1.1,'1.5')
	