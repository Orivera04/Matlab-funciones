% Script p3_3_11.m; VDP for max range with gravity, thrust, & specified
% yf; solution using d(ga)/dt in terms of ga and p=[Vf,gaf]; interpolate
% on p to make y(1)=yf, ga(1)=gaf; s=[y x ga]';            2/97, 3/26/02
%
clear; clear global; s0=[0 0 -pi/2]'; global a yf; a=.5; yf=.1;
p0=[.49 1.08]; optn=optimset('Display','Iter','MaxIter',100); 
p=fsolve('vdpcy',p0,optn); optn1=odeset('reltol',1e-4);
[t,s]=ode23('vdpode',[0 1],s0,optn1,p); y=s(:,1); x=s(:,2); ga=s(:,3);
N=length(t); un=ones(N,1); c=180/pi; Vf=p(1); gaf=p(2); 
V=Vf*cos(ga)./(un*cos(gaf)-a*sin(ga-un*gaf)); 
%
figure(1); clf; plot(x,y,x(N),y(N),'ro',0,0,'ro'); grid; 
axis([0 .36 -.12 .15]); ylabel('y/gt_f^2'); xlabel('x/gt_f^2');
%
figure(2); clf; subplot(211), plot(t,V); grid; ylabel('V');
subplot(212), plot(t,c*ga,0,-90,'ro'); grid;
axis([0 1 -90 90]); xlabel('Time'); ylabel('\gamma (deg)');
	
   