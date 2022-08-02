% Script f08_13.m; minimum distance on a torus;             3/94, 4/4/02
%
% Calculate six paths for beta0 = .2,.4,.6,.8.1,1.25:
[ph2,s2]=ode23('torus',[0 2],[0 .2]');
[ph4,s4]=ode23('torus',[0 2.1],[0 .4]');
[ph6,s6]=ode23('torus',[0 2.2],[0 .6]');
[ph8,s8]=ode23('torus',[0 2.25],[0 .8]');
[ph10,s10]=ode23('torus',[0 2.4],[0 1]');
[ph12,s12]=ode23('torus',[0 3.2],[0 1.25]');
%
% Plot paths on latitude vs. longitude grid:
figure(1); clf; subplot(211), plot(ph2/pi,s2(:,1)/pi); hold on
plot(ph4/pi,s4(:,1)/pi); plot(ph6/pi,s6(:,1)/pi); 
plot(ph8/pi,s8(:,1)/pi); plot(ph10/pi,s10(:,1)/pi); 
plot(ph12/pi,s12(:,1)/pi); hold off; axis([0 1 0 1]) 
grid; xlabel('Longitude/pi'); ylabel('Latitude/pi')
text(.66,.78,'beo=1.25 rad'); text(.62,.41,'1.0')
text(.51,.39,'.8'); text(.42,.33,'.6') 
text(.37,.24,'.4'); text(.34,.14,'.2') 
text(.32,.04,'0'); text(.77,.12,'Outer Equator') 
text(.14,.9,'Inner Equator')
%
% Calculate 3-D paths:
i=0:50; x0=cos(i*pi/25); y0=sin(i*pi/25); z0=i*0;       % Outer equator
xi=.2*x0; yi=.2*y0; zi=i*0;                             % Inner equator
r=.6*ones(size(i))-.4*cos(i*pi/25); z=.4*sin(i*pi/25);  % X-section at x=0
x2= (.6*ones(size(ph2))+.4*cos(s2(:,1))).*sin(ph2);
y2=-(.6*ones(size(ph2))+.4*cos(s2(:,1))).*cos(ph2); z2=.4*sin(s2(:,1)); 
x4= (.6*ones(size(ph4))+.4*cos(s4(:,1))).*sin(ph4);
y4=-(.6*ones(size(ph4))+.4*cos(s4(:,1))).*cos(ph4); z4=.4*sin(s4(:,1)); 
x6= (.6*ones(size(ph6))+.4*cos(s6(:,1))).*sin(ph6);
y6=-(.6*ones(size(ph6))+.4*cos(s6(:,1))).*cos(ph6); z6=.4*sin(s6(:,1)); 
x8= (.6*ones(size(ph8))+.4*cos(s8(:,1))).*sin(ph8);
y8=-(.6*ones(size(ph8))+.4*cos(s8(:,1))).*cos(ph8); z8=.4*sin(s8(:,1)); 
x10= (.6*ones(size(ph10))+.4*cos(s10(:,1))).*sin(ph10);
y10=-(.6*ones(size(ph10))+.4*cos(s10(:,1))).*cos(ph10); z10=.4*sin(s10(:,1)); 
x12= (.6*ones(size(ph12))+.4*cos(s12(:,1))).*sin(ph12);
y12=-(.6*ones(size(ph12))+.4*cos(s12(:,1))).*cos(ph12); z12=.4*sin(s12(:,1)); 

subplot(212); plot(x0,y0); hold on; plot(xi,yi);
plot(x2,y2);   plot(-x2,y2);   plot(x4,y4);   plot(-x4,y4);
plot(x6,y6);   plot(-x6,y6);   plot(x8,y8);   plot(-x8,y8);
plot(x10,y10); plot(-x10,y10); plot(x12,y12); plot(-x12,y12);
hold off; axis([-1.1 1.1 -1.1 1.1]); axis('square')
xlabel('x'); ylabel('y')
%print -deps2 f08_12

% Perspective 3_D plot:
th=[0:.04:1]*pi; ph=[0:.02:1]*2*pi;
r=.6*ones(1,26)+.4*cos(th); z1=.4*sin(th);
for i=1:26, for j=1:51, x(i,j)=r(i)*sin(ph(j)); y(i,j)=...
   -r(i)*cos(ph(j)); z(i,j)=z1(i); end; end
figure(2); clf; surfl(x,y,z); hold on
plot3(x2,y2,z2,x4,y4,z4,x6,y6,z6,x8,y8,z8,x10,y10,z10,x12,y12,z12); 
plot3(-x2,y2,z2,-x4,y4,z4,-x6,y6,z6,-x8,y8,z8,-x10,y10,z10,-x12,y12,z12);
hold off; view(90,82.5); axis([-1 1 -1 1 0 .4]); colormap(white)


