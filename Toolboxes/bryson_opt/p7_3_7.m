% Script p7_3_7.m; DP soln. of min time TDP to rendezvous at 
% x(tf)=r, y(tf)=0; contours of const time-to-go (aT/V) and 
% const thrust direction angle theta on a chart of V^2/(2ar)
% vs. gamma; finds p=(thb0,thbf) in analytic solution to give
% uf=vf=0 & spec. (xf,yf) using FSOLVE; (u,v) in uf, (x,y) 
% in V0^2/a, t in V0/a; V0 in sqrt(2ar); plots optimal paths
% in (V^2/2ar, gamma) space;                    1/97, 7/17/02
%
Vf1=[.1:.1:1.8]; c=pi/180; gaf1=c*[10:2:40 50:10:150];
Nv=length(Vf1); Ng=length(gaf1); tf=zeros(Nv,Ng); thf=tf;
th0=tf; p0=c*[85 -88]; %optn=optimset('Display','Iter');
%for i=1:Nv; for j=1:Ng; Vf=Vf1(i); gaf=gaf1(j);
%p=fsolve('tdpxt1_f',p0,optn,Vf,gaf);
%[f,tf(i,j),thf(i,j)]=tdpxt1_f(p,Vf,gaf);
%end; end
%Vf=[.1:.1:1.8]; for i=1:10,                  % For gaf1=0
%tf0(i)=sqrt(2*(1+1/Vf(i)^2))-1; thf0(i)=pi; end;
%for i=11:18, tf0(i)=sqrt(2*(1-1/Vf(i)^2))+1; thf0(i)=0;
%end; thf0(10)=pi/2;
%gaf1=[0 gaf1]; tf=[tf0' tf]; thf=[thf0' thf];
load \book_do\figures\f07_09;
B=[30:30:150]; T=[1.5:.5:4 6:2:12];
%
figure(1); clf; contour(gaf1/c,Vf1,thf/c,B);
axis([0 180 0 1.8]); xlabel('\gamma (deg)')
ylabel('V/sqrt(2ar)')
% 
figure(2); clf; contour(gaf1/c,Vf1,tf,T); 
axis([0 180 0 1.8]); xlabel('\gamma (deg)');
ylabel('V/sqrt(2ar)');
%
thb1=c*[50 70 80 85 87 88 89]; N=5001; t=[0:.1:500];
un=ones(1,N); for i=1:7,
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
figure(1); hold off; grid; text(2,1.65,'\theta=180')
text(30,1.65,'150'); text(58,1.65,'120'); text(87,1.65,'90')
text(118,1.65,'60'); text(150,1.65,'30'); text(170,1.65,'0')
text(90,1.35,'\theta_f=89'); text(85,1.06,'88')
text(78,.9,'87'); text(68,.75,'85'); text(51,.64,'80')
text(41,.7,'70'); text(28,.83,'50')
%print -deps2 \book_do\figures\f07_09
%
figure(2); hold off; grid; 
text(88,1.45,'\theta_f=89'); text(82,1.06,'88') 
text(78,.9,'87'); text(68,.75,'85'); text(51,.64,'80') 
text(41,.7,'70'); text(28,.83,'50'); text(8,1.5,'aT/V=2.0')
text(110,1.65,'2.5'); text(145,1,'3.0'); text(150,.7,'3.5')
text(150,.58,'4.0'); text(150,.35,'6.0'); text(150,.24,'8.0')
text(155,.17,'10.0'); text(150,.08,'12.0'); text(1,1.1,'1.5')
%print -deps2 \book_do\figures\f07_10



