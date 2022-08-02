% Script e03_4_2.m; TDP for max radius from earth orbit using
% FMINCON; s=[r u v]';                                12/94, 9/13/02 
%
be0=[0.4310 0.4663 0.5045 0.5457 0.5902 0.6380 0.6893 0.7441 ...
     0.8026 0.8648 0.9306 1.0002 1.0735 1.1507 1.2324 1.3196 ...
     1.4151 1.5252 1.6675 1.9044 2.5826 3.9427 4.4209 4.6081 ...
     4.7222 4.8071 4.8768 4.9373 4.9913 5.0407 5.0864 5.1292 ...
     5.1695 5.2077 5.2442 5.2792 5.3129 5.3456 5.3773 5.4083 5.4386];
N1=length(be0); N=N1-1; tf=3.3155; t=tf*[0:1/N:1]; z=180/pi; 
optn=optimset('Display','Iter','MaxIter',0); s0=[1 0 1]';
be=fmincon('marc_f',be0,[],[],[],[],[],[],'marc_c',optn,s0,tf);
[f,s]=marc_f(be,s0,tf); r=s(1,:); u=s(2,:); v=s(3,:);
th=cumtrapz(t,v./r); rf=r(N1); x=r.*cos(th); y=r.*sin(th); 
ep=ones(1,N1)*pi/2+th-be; xt=x+.2*cos(ep); yt=y+.2*sin(ep); 
%
figure(1); clf; plot(x,y,x(N1),y(N1),'ro',0,0,'ro'); grid; hold on 
for i=1:91, th1(i)=(i-1)*pi/90; end; c=cos(th1); s=sin(th1);
plot(c,s,'r--',rf*c,rf*s,'r--',1,0,'ro');
for i=1:2:N1, pltarrow([x(i);xt(i)],[y(i);yt(i)],.05,'r','-'); end 
hold off; axis([-1.6 1.6 -.5 2.2]); ylabel('y/r_e'); xlabel('x/r_e')
text(-.6,.65,'Earth Orbit'); text(-.1,.1,'Sun') 
text(.9,1.3,'Mars Orbit')
%
figure(2); clf; subplot(311), plot(t,r,t,v,'r--'); grid
axis([0 tf .7 1.6]); legend('r','v',2); subplot(312), plot(t,u); 
grid; axis([0 tf 0 .4]); ylabel('u'); subplot(313)
plot(t,z*be,t,z*be,'b.'); grid; axis([0 tf 0 360])
ylabel('\beta (deg)'); xlabel('Time')
