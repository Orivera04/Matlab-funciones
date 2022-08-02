% Script p1_2_10.m; reachable area for the shuttle orbiter from various
% altitudes using const. alpha & sigma; use min glide angle for given
% helix radius; makes plot from analytical solution;     10/96, 6/27/02
%
alm=1/3; eta=1/2; c=pi/180; sg=c*[0:.5:40]; un=ones(1,81); 
al=alm*un./sqrt(cos(2*sg)); ga=atan(eta*(al+alm^2*un./al)./cos(sg));
r=(cos(ga)).^2./(al.*sin(sg)); zp=[2:2:12];
for j=1:6, for i=2:81,
      ps=zp(j)/(r(i)*tan(ga(i))); xz(j,i)=r(i)*sin(ps); 
      yz(j,i)=r(i)*(1-cos(ps)); 
end; end
for j=1:6, xz(j,1)=zp(j)/tan(ga(1)); yz(j,1)=0; end
%
figure(1); clf; k=[81 81 78 67 58 50];
for j=1:6,
   p=[1:k(j)]; plot(xz(j,p),yz(j,p),'b',xz(j,p),-yz(j,p),'b');
hold on; end; hold off
grid; axis([-15 45 -30 30]); axis('square'); xlabel('x/l')
ylabel('y/l'); text(25,23,'z/l=12'); text(23,18,'10')
text(21,13,'8'); text(17,8,'6'); text(13,4.5,'4'); text(7,1.5,'2')
	
	