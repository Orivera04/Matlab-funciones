% Script e09_3_2.m; max range glide with h >=0 and al<almax using
% FMINCON and inverse control with (V,ga) as key state variables; 
% (x,h) by integration, alpha by differentiation;        1/94, 9/17/02
%
tic; N=25; alm=1/12; eta=.5; gas=atan(2*eta*alm); e=180/pi; h0=1; 
un=ones(1,N); Vs=sqrt(cos(gas)/alm); un1=ones(1,N-1); V0=1.1*Vs;
p0=[3*un -.04*un1 23]; lb=[2*un -.05*un1 22]; ub=[V0*un 0*un1 24];
optn=optimset('Display','Iter','MaxIter',30);
p=fmincon('glid_f',p0,[],[],[],[],lb,ub,'glid_c',optn,h0,V0); 
[f,al,x,h]=glid_f(p,h0,V0); V=[V0 p(1:N)]; ga=[0 p(N+1:2*N-1) 0]; 
xb=(x(2:N+1)+x(1:N))/2; x2=x(N+1); V2=V(N+1); xf=-f; Vf=1/sqrt(3*alm);
Ef=Vf^2/2; E0=h0+V0^2/2; E1=h0+Vs^2/2; h1=h0+E0-E1; E2=Vs^2/2;
x1=(E0-E2)/(2*eta*alm); E1f=[E2:(Ef-E2)/20:Ef]; a=4*alm^2;
for i=21:-1:1,
 x1f(i)=x1+(1/(eta*a))*log((1+a*E2^2)/(1+a*E1f(i)^2));
end; V1f=sqrt(2*E1f); al1f=cos(gas)*V1f.^(-2); tf=p(2*N);
%
figure(1); clf; subplot(211), plot(x,h,x,h,'.',[x2 xf],[0 0],...
  xf,0,'o',[x1 xf],[-.02 -.02],'r--',[.2 .2],[h0 h1],'r--',[0 x1],...
  [h1 0],'r--'); ylabel('h/l'); grid; axis([0 72 -.1 2.4]);
text(12,1.7,'Energy State'); text(25,.7,'Mass Point')
text(42,.3,'State Constraint') 
subplot(212), plot(x,V,x,V,'.',xf,Vf,'o',[.2 .2],[V0 Vs],'r--',...
    [0 x1],[Vs Vs],'r--',x1f,V1f,'r--'); grid; axis([0 72 1.8 4])
xlabel('x/l'); ylabel('V/sqrt(gl)'); text(5,3.1,'V_{opt}')
%
figure(2); clf; subplot(211), plot(xb,e*al,xb,e*al,'.',...
 xf,3*e*alm,'o',x1f,e*al1f,'r--',[0 x1],e*alm*[1 1],'r--'); grid
axis([0 70 3 15]); xlabel('x/l'); ylabel('\alpha (deg)')
text(5,7,'\alpha_{opt}'); text(58,13.5,'\alpha_{max}') 
subplot(212), plot(x,e*ga,x,e*ga,'.',[x2 xf],[0 0],xf,0,'o',...
 [0 x1],-e*gas*[1 1],'r--',[.2 .2],[0 -e*gas],'r--',x1*[1 1],...
 [-e*gas 0],'r--',[x1 xf],-.05*[1 1],'r--'); grid 
axis([0 70 -5 1]); ylabel('\gamma (deg)'); xlabel('x/l')
text(3,-3.5,'\gamma_{opt}') 
%
figure(3); clf; plot(V,h,V,h,'.',[Vf V2],[0 0],Vf,0,'o',...
  V0,h0,'o',[Vf Vs],[-.01 -.01],'r--',[Vs Vs],[0 h1],'r--',...
  [V0 Vs],[h0 h1],'r--'); xlabel('V/sqrt(gl)'); ylabel('h/l')
grid; axis([1.8 4 -.1 2.3]); text(3.72,1.75,'Zoom')
text(3.72,1.55,'Climb'); text(3.25,1.25,'V_{opt}')
toc