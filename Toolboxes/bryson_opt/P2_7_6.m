% Script p8_5_6.m; VDP with gravity, thrust, drag & spec. yf; 
% s=[V x y]'; t in sqrt(l/g), V in sqrt(gl), (x,y) in l, a in g; 
% using FOP0N2;                                           7/2/02
%
global a yf sy; a=.05; yf=2; sy=2e2; 
name='vdptd0y'; tf=5; 
load p2_7_6; %tu=t; u0=u; 
%N=30; tu=tf*[0:1/N:1]'; u0=.35*ones(N+1,1);
s0=[0 0 0]'; k=-2e-3; told=1e-3; tols=1e-3; mxit=10;
[t,u,s,la0]=fop0n2(name,tu,u0,tf,s0,k,told,tols,mxit);             
V=s(:,1); x=s(:,2); y=s(:,3); ke=V.^2/2; N1=length(V); c=180/pi; 
%
figure(1); clf; subplot(211), plot(x,-y,'b',0,0,'ro',...
   x(N1),-y(N1),'ro'); grid; xlabel('x'); ylabel('-y')
subplot(212), plot(ke,-y,'b',V(N1)^2/2,-y(N1),'ro',0,0,'ro');
grid; xlabel('V^2/2'); ylabel('-y')
%
figure(2); clf; plot(t,c*u,'b'); grid; xlabel('Time')
ylabel('\gamma (deg)') 
	