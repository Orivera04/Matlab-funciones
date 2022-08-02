% Script p3_6_12n.m; VDP for max range w. gravity, thrust, drag, & 
% spec. yf using FOPCN; s=[V y x]';                  1/94, 5/28/02
%
name='vdpctd'; N=40; tf=5; t=tf*[0:1/N:1]; global a yf; a=.05; 
yf=-.3; s0=[0 0 0]'; nu=1.582; 
ga0=[-1.571  -1.164  -0.818  -0.574  -0.423  -0.327  -0.268...
     -0.231  -0.206  -0.190  -0.180  -0.174  -0.169  -0.166...
     -0.164  -0.163  -0.162  -0.162  -0.161  -0.161  -0.161...
     -0.161  -0.160  -0.160  -0.160  -0.159  -0.158  -0.156...
     -0.154  -0.150  -0.144  -0.135  -0.122  -0.101  -0.069...
     -0.019   0.058   0.180   0.371   0.651   1.007];
p0=[ga0 nu]; optn=optimset('Display','Iter','MaxIter',500); 
c=180/pi; p=fsolve('fopcn',p0,optn,name,s0,tf);
[f,s,la0]=fopcn(p,name,s0,tf); N1=N+1; ga=p([1:N1]); v=s(1,:);
x=s(2,:); y=s(3,:); ke=v.^2/2; vf=v(N1); kef=vf^2/2;
%
% Vertical dive, steady descent, vertical climb path:
gas=-.34; t2=4.4; p0=[gas t2]; 
p=fmincon('vdpctd_f',p0,[],[],[],[],[],[],'vdpctd_c',optn,a,tf,yf);
[f,g,y1,y2,xf]=vdpctd_f(p,a,tf,yf); vc=sqrt(a-sin(p(1)));
kec=vc^2/2; gas=p(1);
% 
figure(1); clf; subplot(211), plot(x,y,x(N1),y(N1),'ro',0,0,'ro',...
   0,0,'ro',[.01 .01],[0 y1],'r--',0,0,'ro',xf,yf,'ro',.01,y1,...
   'ro',[.01 xf],[y1 y2],'r--',[xf xf],[y2 yf],'r--',xf,y2,'ro');
grid; xlabel('x/l'); ylabel('y/l'); subplot(212); plot(ke,y,ke(N1),...
   y(N1),'ro',0,0,'ro',[0 kec],[0 -kec],'r--',[kef kec],...
   [-.3 -.3-kec+kef],'r--',[kec kec],[-.38 -.1],'r--',kec,-kec,...
   'ro',kec,-.3-kec+kef,'ro'); grid; xlabel('V^2/2gl'); ylabel('y/l')
axis([0 .12 -.4 0])
%
figure(2); clf; plot(t,c*ga,[0 tf],c*gas*[1 1],'r--'); grid
xlabel('t*sqrt(l/g)'); ylabel('\gamma (deg)')
	
	