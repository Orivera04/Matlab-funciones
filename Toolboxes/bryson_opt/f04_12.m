% Script f04_12.m; TDP for min time trsfr to Venus orbit; s=[r u v]';
% be=thrust direction angle;                              2/95, 9/5/02
%
clear; clear global; global rf; rf=.7233; name='mart'; s0=[1 0 1]';
k=2; told=1e-5; tols=1e-5;  
%be=[-2.5:.25:2.25]; tf=2.4;              % Crude initial guess
be0=[-2.5405 -2.4777 -2.4104 -2.3372 -2.2565 -2.1661 -2.0633 ...
    -1.9444 -1.8018 -1.6067 -0.4323  1.5976  1.8380  2.0283 ...
     2.1971  2.3465  2.4769  2.5893  2.6854  2.7671]';
tf=2.3962; mxit=50;                  % Converged soln as initial guess
N=length(be0)-1; tu=tf*[0:1/N:1]'; 
load p4_5_18; N1=length(tu); N=N1-1; tf=tu(N1,1); mxit=3;
[t,be,s,tf]=fopt(name,tu,be0,tf,s0,k,told,tols,mxit);
r=s(:,1); u=s(:,2); v=s(:,3); th=cumtrapz(t,v./r); N1=length(t);
%
% Coord. path (xc,yc) & tips of thrust arrows (xt,yt):
xc=r.*cos(th); yc=r.*sin(th); t1(N1)=tf*(1-1e-8);
xt=xc+.3*sin(be-th);  yt=yc+.3*cos(be-th); 
%
% Earth and Venus orbit circles:
th1=2*pi*[0:.02:1]'; xe=cos(th1); ye=sin(th1); xv=.7233*cos(th1);
yv=.7233*sin(th1); 
%
figure(1); clf; plot(xc,yc,xe,ye,'r--',xv,yv,'r--',0,0,'ro',1,0,'ro');
hold on; for i=1:2:N1, pltarrow([xc(i);xt(i)],[yc(i);yt(i)],.04,'r','-');
end; hold off; grid; axis([-1.1 1.1 -.4 1.25]); xlabel('x/r_o')
ylabel('y/r_o'); text(-.35,.5,'VENUS ORBIT'); text(-.18,.1,'SUN')
text(-.95,.9,'EARTH ORBIT')  

