% Script p2_4_5.m;  VDP for max range with gravity & thrust;
% a=g;                                           2/97, 7/2/02
%
name='vdpt0'; N=40; tf=1; tu=tf*[0:1/N:1]'; u=.4*ones(N+1,1); 
s0=[0 0 0]'; k=-1; told=1e-5; tols=1e-4; mxit=50;
[t,u,s,la0]=fop0(name,tu,u,tf,s0,k,told,tols,mxit);             
x=s(:,2); y=s(:,3); N2=length(x);
%
% a=0 case for comparison (see Pb. 2.3.2):
ga=(pi/2)*[1:-1/N:0]; un=ones(1,N+1); alo=pi/4; al=ga/2;
x1=(4/pi^2)*((alo*un-al)-(1/4)*sin(2*ga));
y1=(2/pi^2)*(cos(ga)).^2; t1=(4/pi)*(alo*un-al);
%
figure(1); clf; plot(x,-y,x1,-y1,'r--',x(N2),-y(N2),...
  'ro',x1(N+1),-y1(N+1),'o'); grid; axis([0 .8 -.6 0]) 
xlabel('x'); ylabel('y')
%
figure(2); clf; plot(t,x,t,-y,t1,x1,'r--',t1,-y1,'r--');
grid; xlabel('Time'); legend('x','y')
	