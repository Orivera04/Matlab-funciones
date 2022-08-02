% Script p9_3_15.m; F4 min time to climb using inverse optimization 
% with SVIC h>=0; (Vo,ho,gao) and (Vf,hf,gaf) specified; h in lc where
% lc=2W/(g*rho*S), m in mo, T in g*mo=Wo, V in sqrt(g*lc), t in
% sqrt(lc/g);                                           9/94,  5/18/02
% 
Wo=41998; S=530; ep=3*pi/180; c=1600; rho=.002378; gr=32.2;
lc=2*Wo/(gr*rho*S); Vc=sqrt(gr*lc); tc=lc/Vc; c=c/tc;
Vo=440/Vc; ho=0; Vf=968.1/Vc; hf=65673/lc;
%        
% Initial guess of p=[V(t) ga(t) tf]:
load vrtpl; N=60; p=p60;                 % Converged soln., N=60
%load vrtpl; N=30; p=p30;  		          % Converged soln., N=30 
un=ones(1,N); un1=ones(1,N-1); tf=p(2*N-1);
ub=[(1900/Vc)*un1  (50*pi/180)*un1 60];
lb=[ (400/Vc)*un1 -(20*pi/180)*un1 20]; 
optn=optimset('display','iter','maxiter',1);
p=fmincon('climb_f',p,[],[],[],[],lb,ub,'climb_c',optn,N,Vo,ho,Vf,hf);
[f,Tmax,h,x,m,alp,ng]=climb_f(p,N,Vo,ho,Vf,hf);      
V=[Vo p(1:N-1) Vf]; ga=[0 p(N:2*N-2) 0]; tf=p(2*N-1); 
%
% Spline outputs to double number of points for plotting:
dt=1/N; t=[0:dt:1]; tb=[dt/2:dt:1-dt/2]; ti=[0:dt/2:1];
Vi=(Vc/1000)*spline(t,V,ti); gai=(180/pi)*spline(t,ga,ti);
tbi=[dt/4:dt/2:1-dt/4]; alpi=(180/pi)*spline(tb,alp,tbi);
ngi=spline(tb,ng,tbi); Ti=spline(tb,Tmax,tbi); 
xi=(lc/1000)*spline(t,x,ti); hi=(lc/1000)*spline(t,h,ti);
%
ttl='F4 Min Time Climb, Mf=1.00, hf=20 km, h>=0';
figure(1); clf; subplot(511), plot(ti,Vi,ti,Vi,'.'); grid;  
ylabel('V (kft/sec)'); title(ttl); 
subplot(512), plot(ti,gai,ti,gai,'.'); grid;
ylabel('\gamma (deg)'); subplot(513), plot(tbi,alpi,tbi,alpi,'.');
grid; ylabel('\alpha (deg)');
subplot(514), plot(tbi,ngi,tbi,ngi,'.'); grid
ylabel('Load Factor');  subplot(515), plot(tbi,Ti,tbi,Ti,'.'); 
grid; ylabel('Thrust/Wo'); xlabel('t/tf');
%
figure(2); clf; plot(xi,hi,xi,hi,'.'); grid;
axis([0 450 0 70]); xlabel('x (kft)');
ylabel('h (kft)'); title(ttl); 
%
figure(3); clf; plot(Vi,hi,Vi,hi,'.',Vi(2*N+1),hi(2*N+1),'o'); 
grid; hold on; plot(Vi(1),hi(1),'o'); hold off; axis([0 2 0 70]);
xlabel('V (kft/sec)'); ylabel('h (kft)'); axis([ 0 2 -2 70]); 
title(ttl); text(.55,4,'SVIC h>=0'); 
