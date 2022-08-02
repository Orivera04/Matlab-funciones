% Script f03_19.m; VDP for max range with gravity, thrust, drag, and
% specified yf; s=[V x y]';                             1/94, 7/16/02
%
global a yf; a=.05; yf=-.3; N=50; N1=N+1; tf=5; name='vdpctd';
s0=[0 0 0]'; k=-.7; told=1e-5; tols=1e-5; mxit=6; 
%tu=tf*[0:1/N:1]'; ga0=-.16*ones(N1,1); 
load p3_4_12;                                         % Converged tu 
[t,ga,s]=fopc(name,tu,ga0,tf,s0,k,told,tols,mxit);
v=s(:,1); x=s(:,2); y=s(:,3); c=180/pi; ga=ga*c; N2=length(x);
ke=v.^2/2; kef=ke(N2); un=ones(N2,1); vf=v(N2); gaf=ga(N2); 
g=v./cos(ga)-un*vf/cos(gaf)-v.*(a*un-v.^2).*(tan(ga)-un*tan(gaf));
%
% Approx. max range path (zoom dive, steady descent, zoom climb):
gac=-.34; t2=4.4; tf=5; p0=[gac t2]; 
optn=optimset('Display','Iter','MaxIter',30);
p=fmincon('vdpctd_f',p0,[],[],[],[],[],[],'vdpctd_c',optn,a,tf,yf);
[ceq,c,y1,y2,xf]=vdpctd_c(p,a,tf,yf); vc=sqrt(a-sin(p(1))); kec=vc^2/2;
% 
figure(1); clf; subplot(211), plot(x,y,x(N2),y(N2),'ro',0,0,'ro',...
   [.001 .001],[0 y1],'r--',.001,y1,'ro',xf,yf,'ro',xf,yf,'ro',...
   [.001 xf],[y1 y2],'r--',[xf xf],[y2 yf],'r--',xf,y2,'ro');
grid; axis([0 2 -.4 0]); xlabel('x/l'); ylabel('y/l')  
subplot(212); plot(ke,y,ke(N2),y(N2),'ro',0,0,'ro',...
   [0 kec],[0 y1],'r--',[kef kec],[yf y2],'r--',[kec kec],...
   [y1 y2],'r--',kec,y1,'ro',kec,y2,'ro',kef,yf,'ro'); grid
axis([0 .11 -.4 0]); xlabel('V^2/2gl'); ylabel('y/l') 
text(.042,-.12,'Vertical Dive'); text(.042,-.28,'Vertical Climb')
text(.081,-.24,'Steady Descent')
%
figure(2); clf; subplot(211), plot(t,v); ylabel('V'); grid
subplot(212), plot(t,ga); grid; axis([0 tf -90 60]);
xlabel('t*sqrt(l/g)'); ylabel('\gamma (deg)')
	
	