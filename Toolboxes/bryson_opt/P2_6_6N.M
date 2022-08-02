% Script p2_6_6n.m; VDP for max range with gravity, thrust, and drag
% using FOP0N; s=[V x y]'; t in sqrt(l/g), V in sqrt(gl), (x,y) in l,
% a in g;                                                2/95, 6/30/02
%
global a; a=1; tf=3; s0=[0 0 0]'; k=-1; tol=3e-3; mxit=50;
name='vdptd0'; optn=optimset('Display','Iter','MaxIter',500); 
u0=[1.571 1.220 .945 .757 .632 .548 .491 .450 .421 ...
    .400 .385 .373 .364 .356 .351 .345 .341 .336 .332 .326 .320 ...
    .313 .303 .291 .275 .254 .226 .190 .143 .081 0]; 
u=fsolve('fop0n',u0,optn,name,s0,tf); [f,s,la0]=fop0n(u,name,s0,tf);
N1=length(u0); N=N1-1; c=180/pi; t=tf*[0:1/N:1]'; V=s(1,:); x=s(2,:);
y=s(3,:); ke=V.^2/2;
%
% Vert. dive to V(ts)=Vs, y(ts)=ys, then ga= gas for comparison:
Vs=sqrt(2*a/3+sqrt((a/3)^2+1/3));              % V for max steady xdot
gas=-asin(sqrt((a/3)^2+1/3)-a/3);             % ga for max steady xdot
b=sqrt(1+a); ts1=atanh(Vs/b)/b; ys=-log(cosh(ts1*b));               
xfs=Vs*cos(gas)*(tf-ts1); yfs=ys+xfs*tan(gas); kes=Vs^2/2;
%
figure(1); clf; subplot(211), plot(x,-y,'b',x,-y,'b.',[0 xfs],[ys yfs],...
   'r--',[.01 .01],[0 ys],'r--',0,0,'ro',.01,ys,'ro',xfs,yfs,'ro',...
   x(N1),-y(N1),'bo'); grid; xlabel('x'); ylabel('-y')
subplot(212), plot(ke,-y,'b',ke,-y,'b.',[kes,kes],[ys yfs],'r--',...
   kes,ys,'ro',kes,yfs,'ro',[0 kes],[0 ys],'r--',V(N1)^2/2,...
   -y(N1),'bo',0,0,'ro'); grid; xlabel('V^2/2'); ylabel('-y')
%
figure(2); clf; plot(t,c*u,'b',t,c*u,'b.',[0 tf],-c*[gas gas],'r--');
grid; xlabel('Time'); ylabel('\gamma (deg)') 
