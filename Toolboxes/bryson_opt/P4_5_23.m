% Script p4_5_23.m; min time climb, A/C w. parabolic lift-drag polar;
% s=[V ga h]'; u=alpha; h in l, V in sqrt(g*l), l=2m/(rho*S*Cla);
% alm=1/12; eta=1/2; T=.2; Vo=Vf=7, gaf=0; hf=11.3;    11/96, 9/5/02
%
clear; name='climbt';
al0=.1*[.688 .492 .365 .286 .244 .232 .244 .274 .315 .360 .403 .441 ...
   .471 .493 .508 .514 .513 .503 .482 .450 .407 .356 .301 .251 .214 ...
   .197 .206 .246 .317 .429 .594]';
N=length(al0)-1; tf=30; tu=tf*[0:1/N:1]'; s0=[7 0 0]';
k=4e-4; told=1e-4; tols=1e-4; mxit=2; c=180/pi;
[t,al,s,tf,nu,la0]=fopt(name,tu,al0,tf,s0,k,told,tols,mxit);
V=s(:,1); ga=s(:,2); h=s(:,3); x=cumtrapz(V.*cos(ga));
N1=length(V); es=4.630^2/2; ke=V.^2/2;
%
figure(1); clf; plot(ke,h,[es 24.5],[27.96 13.78],'--',[es 24.5],...
   [13.78 0],'--',[es es],[13.78 27.96],'--',24.5,0,'o',24.5,...
   h(N1),'o'); grid; axis([0 30 0 30]); axis('square');
xlabel('V^2/2gl'); ylabel('h/l');
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],4.63*[ 1 1],'--');
grid; ylabel('V'); subplot(212), plot(t,c*ga,[0 tf],c*.1023*[1 1],...
   '--'); grid; ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)');
%
figure(3); clf; subplot(211), plot(t,h,[0 0],[0 13.78],'--',...
   [tf tf],[27.96 14.18],'--',[0 tf],[13.78 27.96],'--'); grid;
ylabel('h'); subplot(212), plot(t,c*al,[0 tf],c*.0466*[1 1],'--');
grid; ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)');

	
