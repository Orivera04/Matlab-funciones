% Script p7_3_2.m; min time paths to x=0, y=0 with gravity (DP soln
% of Brach. Pb.);                                     12/96, 7/8/02
%
c=pi/180; gaf1=c*[0:15:75]; ga=c*[0:2:90]; un=ones(1,length(ga));
%
figure(1); clf; for i=1:6, gaf=gaf1(i);
 x=((ga-gaf*un+(sin(2*ga)-un*sin(2*gaf))/2))/(cos(gaf))^2;
 y=un-(cos(ga)/cos(gaf)).^2;  plot(x,y); hold on; end;
plot([0 0],[0 1]); axis([0 1.6 0 1.2]); ga1=c*[0:15:75];
gaf=c*[0:2:90]; for i=1:6, ga=ga1(i);
 x=((ga*un-gaf+(un*sin(2*ga)-sin(2*gaf))/2))./(cos(gaf)).^2;
 y=un-(un*cos(ga)./cos(gaf)).^2;  plot(x,y,'r--'); end;
plot([0 pi/2],[1 1],'r--'); grid; hold off; xlabel('gx/E');
ylabel('gy/E'); text(-.03,1.05,'90'); text(.16,1.05,'75');
text(.34,1.05,'60'); text(.54,1.05,'45');
text(.62,1.12,'\gamma_f (deg)'); text(.8,1.05,'30');
text(1.10,1.05,'15'); text(1.56,1.05,'0'); text(1.26,1.08,'90'); 
text(1.14,.87,'\gamma (deg)'); text(1.26,.96,'75');
text(1.22,.78,'60'); text(1.02,.53,'45'); text(.72,.28,1.05,'30');
text(.40,.10,'15'); text(1.24,.25,'E = V^2/2 + gy')
%
ga=c*[0:2:90]; un=ones(1,length(ga));
%
figure(2); clf; for i=1:6, gaf=gaf1(i);
 x=((ga-gaf*un+(sin(2*ga)-un*sin(2*gaf))/2))/(cos(gaf))^2;
 y=un-(cos(ga)/cos(gaf)).^2;  plot(x,y); hold on;end
plot([0 0],[0 1]); axis([0 1.6 0 1.2]);
T=[1:-.25:.25]; for i=1:4,
 gaf=c*[0:2:88]; un=ones(1,length(gaf)); ga=gaf+T(i)*cos(gaf);
 x=((ga-gaf+(sin(2*ga)-sin(2*gaf))/2))./(cos(gaf)).^2;
 y=un-(cos(ga)./cos(gaf)).^2;  plot(x,y,'r--'); end 
hold off; grid; xlabel('gx/E'); ylabel('gy/E');
text(-.03,1.05,'90'); text(.16,1.05,'75'); text(.34,1.05,'60');
text(.54,1.05,'45'); text(.62,1.12,'\gamma_f (deg)'); 
text(.8,1.05,'30'); text(1.10,1.05,'15'); text(1.56,1.05,'0');
text(.9,.48,'gT/sqrt(2E)'); text(1.25,.85,'1.00');
text(1.15,.6,'.75'); text(.89,.33,'.50'); text(.49,.15,'.25');
text(1.24,.25,'E = V^2/2 + gy')
%
% Part (f); example inverse calculation for feedback:
x=.8, y=.4, ga=c*45; gaf=c*30; p=[ga gaf]; optn(1)=1;
p=fsolve('vdp_dp',p,optn,[],x,y); ga=p(1); gaf=p(2);
T=(ga-gaf)/cos(gaf), ga=ga/c, gaf=gaf/c


	

	