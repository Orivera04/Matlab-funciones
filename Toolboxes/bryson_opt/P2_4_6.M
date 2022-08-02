% Script p2_4_6.m; VDP with gravity, thrust and drag; s=[V x y]';
% t in sqrt(l/g), V in sqrt(gl), (x,y) in l, a in g; 2/95, 7/2/02
%
global a; a=.05; name='vdptd0'; N=30; tf=5; tu=tf*[0:1/N:1]';
u=.35*ones(N+1,1); s0=[0 0 0]'; k=-.5; told=1e-5; tols=1e-5;
mxit=18; [t,u,s,la0]=fop0(name,tu,u,tf,s0,k,told,tols,mxit);             
V=s(:,1); x=s(:,2); y=s(:,3); ke=V.^2/2; N1=length(V); c=180/pi; 
%
% Vert. dive to V(ts)=Vs, y(ts)=ys, then ga= gas for comparison:
Vs=sqrt(2*a/3+sqrt((a/3)^2+1/3));         % V for max steady xdot
gas=-asin(sqrt((a/3)^2+1/3)-a/3);        % ga for max steady xdot
b=sqrt(1+a); ts1=atanh(Vs/b)/b; ys=-log(cosh(ts1*b));               
xfs=Vs*cos(gas)*(tf-ts1); yfs=ys+xfs*tan(gas); kes=Vs^2/2;
%
figure(1); clf; subplot(211), plot(x,-y,'b',[0 xfs],[ys yfs],...
   'r--',[.01 .01],[0 ys],'r--',0,0,'ro',.01,ys,'ro',xfs,yfs,'ro',...
   x(N1),-y(N1),'bo'); grid; xlabel('x'); ylabel('-y')
subplot(212), plot(ke,-y,'b',[kes,kes],[ys yfs],'r--',...
   kes,ys,'ro',kes,yfs,'ro',[0 kes],[0 ys],'r--',V(N1)^2/2,...
   -y(N1),'bo',0,0,'ro'); grid; xlabel('V^2/2'); ylabel('-y')
%
figure(2); clf; plot(t,c*u,'b',[0 tf],-c*[gas gas],'r--');
grid; xlabel('Time'); ylabel('\gamma (deg)') 
	