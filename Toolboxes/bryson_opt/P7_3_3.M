% Script p7_3_3.m; min distance paths to New York from all over
% the world;		                            12/96,  7/23/02
%
c=pi/180; phf=-73.8*c; thf=40.7*c; 
al1=[phf-pi/12:-pi/12:phf-pi+pi/15]; N=length(al1);
%
figure(1); clf; plot(phf/c,thf/c,'o'); hold on
for i=1:N, al=al1(i); thm=atan(tan(thf)/sin(phf-al));
   ph=[-pi:.02:phf]; un=ones(1,length(ph)); 
   th=atan(tan(thm)*sin(ph-al*un)); plot(ph/c,th/c);
end; clear al1
al1=[phf+pi/12:pi/12:phf+pi-pi/15]; N=length(al1);
for i=1:N, al=al1(i); thm=atan(tan(thf)/sin(phf-al));
 ph=[phf:.02:pi]; un=ones(1,length(ph));
 th=atan(tan(thm)*sin(ph-al*un)); plot(ph/c,th/c);
end;
plot((phf/c)*[1 1],[-90 90],(phf/c+180)*[1 1],[-90 90],116,...
   -31-5/60,'o',18+22/60,-33-55/60,'ro',139.75,35.67,'ro',...
   -157-51/60,21+18/60,'ro',-64.33,-33.25,'ro',37.6,55.75,'ro');
grid;  hold off; text(-66,-27,'Rio'); text(36,60,'Moscow') 
axis([-180 180 -90 90]);text(143,42,'Tokyo') 
text(-160,27,'Honolulu'); text(-60,50,'New York')
text(125,-25,'Perth'); text(19,-30,'Capetown')
xlabel('Longitude (deg)'); ylabel('Latitude (deg)')