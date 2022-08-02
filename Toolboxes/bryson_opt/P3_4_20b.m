% Script p3_4_20b.m; max radius orbit transfer Earth to Jupiter orbit;
%                                                       12/96, 9/5/02
%
tf=8.22; name='marc'; c=180/pi; s0=[1 0 1]'; k=-1; told=1e-5;
tols=3e-3; mxit=10;
be0=[-5.8791 1.5840 10.3787 20.5102 31.5039 42.6631 53.3014...
    62.8791  71.0961  77.8853  83.3052  87.7998 267.6986 273.8618...
   275.8958 277.7814 279.5223 281.1851 282.8285 284.5102 286.2905]';
be0=be0/c; N=length(be0)-1; tu=tf*[0:1/N:1]'; 
[t,be,s]=fopc(name,tu,be0,tf,s0,k,told,tols,mxit); 
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); N1=length(t); 
rf=r(N1); x=r.*cos(th); y=r.*sin(th); N1=length(u);
xt=x+.75*sin(be-th); yt=y+.75*cos(be-th); th1=[0:6:360]/c; be=be*c;
xj=rf*cos(th1); yj=rf*sin(th1); xe=cos(th1); ye=sin(th1); t=t/tf;
%
figure(1); clf; plot(x,y,x(N1),y(N1),'bo',xj,yj,'r--',0,0,'o',...
   xe,ye,'r--',1,0,'bo'); hold on 
for i=1:2:N1, pltarrow([x(i);xt(i)],[y(i);yt(i)],.15,'r','-'); end
grid; axis([-6 1.2 -1.4 4]); hold off; xlabel('x/r_o');
ylabel('y/r_o'); text(-2.5,-.8,'EARTH ORBIT'); 
text(-4.8,1.2,'JUPITER ORBIT'); text(-.5,.5,'SUN') 
%
figure(2); clf; subplot(211), plot(t,u,t,v,'r--',t,r,'k-.');
grid; legend('u','v','r',2); subplot(212), plot(t,be); grid
ylabel('\beta (deg)'); xlabel('t/t_f')

   
   
	