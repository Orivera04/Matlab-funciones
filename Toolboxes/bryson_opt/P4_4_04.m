% Script p4_4_04.m; min time to a point with V=1+y;  12/96, 3/29/02
%
c=pi/180; xf=2.5; yf=0; p=[pi/4 -pi/4]; 
optn=optimset('Display','Iter','MaxIter',100); 
p=fsolve('frmt_f',p,optn,xf,yf); th0=p(1); thf=p(2); dth=th0-thf;
th=[th0:-dth/40:thf]; N=length(th); un=ones(1,N);
x=(un*sin(th0)-sin(th))/cos(th0); y=-un+cos(th)/cos(th0);
t=un*asinh(tan(th0))-asinh(tan(th));
%
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid;
xlabel('x/h'); ylabel('y/h'); axis([0 2.6 -.75*.8 .75*1.8]);
%
figure(2); clf; plot(t,th/c); grid; xlabel('V*t/h');
ylabel('\theta (deg)'); 


