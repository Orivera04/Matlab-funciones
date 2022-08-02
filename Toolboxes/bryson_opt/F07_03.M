% Script f07_03.m; family of min time paths to x=y=0 with 
% uc=-Vy/h (DP soln. of Zerm. Pb.);         12/96, 4/4/02
%
c=pi/180; figure(1); clf; figure(2); clf; 
thf1=c*[-60:30:60]; N=length(thf1);
for i=1:N, thf=thf1(i); th0=atan(tan(thf)-2.5);
 dth=(thf-th0)/100; th=[thf:-dth:th0]; ta=tan(th);
 M=length(th);  un=ones(1,M);  se=un./cos(th);
 sef=un/cos(thf); taf=un*tan(thf); t=taf-ta; 
 y=sef-se;  x=(sef.*t-ta.*y+asinh(taf)-asinh(ta))/2;
 figure(1); plot(x,y,-x,-y); hold on;
 figure(2); plot(x,y,-x,-y); hold on; 
end;
clear x y; y=[0:.05:1]; x=y.^2/2; plot(x,y,-x,-y);
figure(1); plot(x,y,-x,-y); grid; axis([-1.3 1.3 -1 1])
ylabel('y/h'); xlabel('x/h')
figure(2); grid; axis([-1.3 1.3 -1 1])       
ylabel('y/h'); xlabel('x/h')
%
% Contours of constant time-to-go, tf:
clear; c=pi/180; thf1=c*[88:-4:-88]; 
un=ones(1,length(thf1)); taf=tan(thf1);
sef=un./cos(thf1); t01=[.25:.25:2.25];
for i=1:9, 
  ta0=taf-t01(i)*un; th0=atan(ta0);
  se0=un./cos(th0); y0=sef-se0; tf=taf-ta0;
  x0=(sef.*tf-ta0.*y0+asinh(taf)-asinh(ta0))/2;
  figure(1); plot(x0,y0,'--',-x0,-y0,'--');
end; hold off
text(1.18,.53,'1.0'); text(.8,.48,'V*tf/h=.75')
text(.5,.34,'.50'); text(.25,.2,'.25')
text(.43,.84,'thf=90 deg'); text(.75,.75,'60')
text(.85,.2,'30'); text(.72,-.25,'0')
text(.4,-.55,'-30'); text(.09,-.75,'-60')
text(-.28,-.85,'-90');text(-.82,-.73,'-120')
text(-1,-.2,'-150'); text(-.82,.25,'180') 
text(-.32,.65,'150'); text(.03,.84,'120')
%print -deps2 \book_do\figures\f07_04
%
% Contours of constant control, th0:
clear; c=pi/180; th01=c*[-75 -60 -45 -30 0  30 60]; 
thf1=c*[-65 25 30 50 60 70 80];  N=length(th01);
for i=1:N, th0=th01(i); dthf=(thf1(i)-th0)/30; 
  thf=[th0:dthf:thf1(i)]; un=ones(1,length(thf));
  taf=tan(thf); ta0=tan(th0)*un; tf=taf-ta0;
  se0=un/cos(th0); sef=un./cos(thf); y0=sef-un/cos(th0);  
  x0=(sef.*tf-ta0.*(sef-se0)+asinh(taf)-asinh(ta0))/2;
  figure(2); plot(x0,y0,'--',-x0,-y0,'--');
end; hold off
text(.3,.72,'th=90 deg'); text(.65,.66,'60')
text(.76,.44,'30'); text(.8,.2,'0')
text(.8,-.19,'-30'); text(.65,-.5,'-45')
text(.42,-.88,'-60'); text(-.25,-.82,'-75')
text(-.52,-.82,'-90'); text(-.85,-.75,'-135')
text(-.95,-.5,'-150'); text(-1,-.21,'180')
text(-.9,.19,'150'); text(-.9,.47,'135')
text(-.25,.85,'120'); text(.15,.85,'105') 
%print -deps2 \book_do\figures\f07_03
	