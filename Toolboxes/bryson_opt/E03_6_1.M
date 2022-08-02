% Script e03_6_1.m; max radius transfer in given time using FOPCN;
%                                                       3/97, 7/12/02
%
%be=[.5:.125:5.5];
be=[.4310   .4663   .5045  0.5457  0.5902  0.6380  0.6893  0.7441 ...
   0.8026  0.8648  0.9306  1.0002  1.0735  1.1507  1.2324  1.3196 ...
   1.4151  1.5252  1.6675  1.9044  2.5826  3.9427  4.4209  4.6081 ...
   4.7222  4.8071  4.8768  4.9373  4.9913  5.0407  5.0864  5.1292 ...
   5.1695  5.2077  5.2442  5.2792  5.3129  5.3456  5.3773  5.4083 ...
   5.4386];
s0=[1 0 1 0]'; tf=3.3155; name='marc'; nu=[-1.4229 1.2638]; p0=[be nu];
optn=optimset('Display','Iter','MaxIter',60,'TolX',1e-5);
p=fsolve('fopcn',p0,optn,name,s0,tf); c=180/pi; 
[f,s,be,la0,Hu,psi]=fopcn(p,name,s0,tf); r=s(1,:); u=s(2,:); v=s(3,:);
th=s(4,:); N1=length(be); N=N1-1; t=tf*[0:1/N:1]; rf=r(1,N1);
x=r.*cos(th); y=r.*sin(th); for i=1:91, th1(i)=(i-1)*pi/90; end
%
figure(1); clf; plot(x,y,1,0,'ro',x(N1),y(N1),'ro',cos(th1),sin(th1),...
   'r--',rf*cos(th1),rf*sin(th1),'r--'); grid; axis([-1.6 1.6 0 2.4])
ylabel('y'); xlabel('x')
%
figure(2); clf; plot(t,u,t,v,'r--',t,r,'k-.'); grid
legend('u','v','r',2); xlabel('Time')
%
figure(3); clf; plot(t,be*c); grid; ylabel('\beta (deg)')
xlabel('Time')

