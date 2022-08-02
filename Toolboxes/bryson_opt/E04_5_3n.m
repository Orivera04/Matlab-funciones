% Script e04_5_3n.m; min time-to-climb to 20 km, M=1, ga=0 for F4 
% aircraft with FOPTN; starts from V=929 ft/sec & W=Wo*.9888 (where
% climb begins); uses 62 points;                      2/97, 5/28/02
%
W=.9888*41998; g=32.2; rho=.002378; S=530; lc=2*W/(g*rho*S);
Vc=sqrt(g*lc); Vo=929/Vc; ho=50/lc; s0=[Vo 0 ho .9888 0]';
tc=lc/Vc; c=180/pi; name='f4_clmb'; 
al=[3.7262 2.8873 1.8322  1.1630  0.8692  0.8326 0.9394 ...
  	1.1085 1.2805 1.4021  1.4119  1.2443  0.8776 0.4481 ...
  	0.2862 0.5672 1.0673  1.5192  1.8166  1.9450 1.9261 ...
  	1.8209 1.6788 1.5349  1.4101  1.3134  1.2458 1.2041 ...
  	1.1827 1.1759 1.1785  1.1862  1.1957  1.2046 1.2109 ...
  	1.2133 1.2105 1.2019  1.1872  1.1672  1.1442 1.1225 ...
  	1.1093 1.1149 1.1526  1.2380  1.3868  1.6115 1.9167 ...
  	2.2933 2.7143 3.1355  3.5065  3.7521  3.8244 3.6983 ...
  	3.3263 2.5847 1.2358 -0.9722 -3.9512 -6.9394]/c;
nu=[-12.6348 .2526 -43.9382]; tf=37.1518;    % Converged soln
p0=[al nu tf]; optn=optimset('Display','Iter','MaxIter',500); 
%load e04_5_3n; p0=p;                           % Converged p
p=fsolve('foptn',p0,optn,name,s0);
[f,s,la0]=foptn(p,name,s0); N=length(p)-4; 
V=s(1,:)*Vc/1000; ga=c*s(2,:); h=(lc/1000)*s(3,:);
x=(lc/1000)*s(5,:); alp=c*p([1:N]); tf=p(N+4); 
%
% Spline outputs to double number of points:
dt=1/(N-1); t=[0:dt:1];  ti=[0:dt/2:1];
Vi=spline(t,V,ti); gai=spline(t,ga,ti); alpi=spline(t,alp,ti); 
xi=spline(t,x,ti); hi=spline(t,h,ti);
V1=[0:.1:2.4]; for i=1:13, for j=1:length(V1),
h1(i,j)=i*10-V1(j)^2/(.0322*2); end; end
%
figure(1); clf; plot(Vi,hi,Vi,hi,'.'); grid; axis([0 2 0 70])   
hold on; for i=1:13, plot(V1,h1(i,:),'--'); end
Vo=.442; Vf=.9681; hf=20/.3048; Vcl=.9294; 
plot(Vo,0,'o',Vcl,0,'o',Vf,hf,'o'); hold off 
text(.25,52,'E = constant'); text(.24,2.5,'Initial point')
text(1.08,65,'Final point'); text(.65,7,'Begin Climb')
xlabel('V (kft/sec)'); ylabel('h (kft)')
% 
figure(2); clf;  plot(xi,hi,xi,hi,'.'); grid
axis([0 400 0 70]); xlabel('x (kft)'); ylabel('h (kft)')
%
ti=tf*tc*ti;
figure(3); clf; subplot(211), plot(ti,alpi,ti,alpi,'.');
grid; axis([0 300 -7 4]); ylabel('\alpha (deg)')
subplot(212), plot(ti,gai,ti,gai,'.'); grid; axis([0 300 -20 40]) 
xlabel('Time (sec)'); ylabel('\gamma (deg)')
	
