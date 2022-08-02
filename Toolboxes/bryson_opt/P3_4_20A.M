% Script p3_4_20a.m; max radius orbit transfer; Earth to Mars; 
%                                                  12/96, 9/5/02
%
name='marc'; be0=[.5:.125:5.5]'; tf=3.3155; N=length(be0)-1; 
tols=5e-4; tu=tf*[0:1/N:1]'; s0=[1 0 1]'; k=-3; told=1e-5;
mxit=15; [t,be,s]=fopc(name,tu,be0,tf,s0,k,told,tols,mxit); 
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); N1=length(t);
rf=r(N1); t=t/tf; x=r.*cos(th); y=r.*sin(th); 
for i=1:91, th1(i)=(i-1)*pi/90; end
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',1,0,'ro'); grid
hold on; plot(cos(th1),sin(th1),'r--',rf*cos(th1),...
  rf*sin(th1),'r--'); hold off; axis([-1.6 1.6 0 2.4])
ylabel('y'); xlabel('x')
%
figure(2); clf; subplot(211), plot(t,u,t,v,'r--',t,r,'k-.');
grid; legend('u','v','r',2); subplot(212), plot(t,180*be/pi); 
grid; ylabel('\beta (deg)'); xlabel('t/t_f')

   
   
	