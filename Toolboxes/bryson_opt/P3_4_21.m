% Script p3_4_21.m; min radius orbit transfer; Earth to Venus orbit;
%                                                         12/96, 9/5/02
%
be0=[-2.540 -2.477 -2.410 -2.337 -2.256 -2.166 -2.063 -1.944 -1.801 ...
    -1.606 -0.432  1.597  1.838  2.028  2.197  2.346  2.476  2.589 ...
     2.685  2.767]'; tf=2.3962;       % Converged soln as initial guess
name='marc'; N=length(be0)-1; tu=tf*[0:1/N:1]';  
s0=[1 0 1]'; k=-.01; told=1e-5; tols=1e-5; mxit=5; c=180/pi; 
[t,be,s,nu,la0]=fopc(name,tu,be0,tf,s0,k,told,tols,mxit); 
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); N1=length(t); 
rf=r(N1);
%
% Coord of path (xc,yc) & tips of thrust arrows (xt,yt):
xc=r.*cos(th); yc=r.*sin(th); t1(N1)=tf*(1-1e-8);
xt=xc+.35*sin(be-th); yt=yc+.35*cos(be-th);  
for i=1:181, th1(i)=(i-1)*pi/90; end
%
figure(1); clf; plot(cos(th1),sin(th1),'r--',rf*cos(th1),...
    rf*sin(th1),'r--'); hold on; plot(xc,yc,'b.',xc,yc,0,0,'ro');
for i=1:2:N1, pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.04,'r','-'); end
hold off; grid; axis([-1.1 1.1 -.4 1.25]); 
xlabel('x/ro'); ylabel('y/ro'); text(-.35,.5,'VENUS ORBIT'); 
text(-.95,.9,'EARTH ORBIT'); text(-.18,.1,'SUN')
%
figure(2); clf; plot(t,u,t,v,'r--',t,r,'c-.'); grid; 
legend('u','v','r',2); xlabel('Time');
%
figure(3); clf; plot(t,c*be); grid; ylabel('\beta (deg)');
xlabel('Time')

   
   
	