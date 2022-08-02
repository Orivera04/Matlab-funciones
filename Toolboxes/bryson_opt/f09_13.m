% Script f09_13.m; max range glide with h >=0 and al<almax using
% inverse optimal control and FMINCON; (V,ga) key state variables, 
% (x,h) by integration, alpha by differentiation;    11/94, 8/7/01
%
tic; N=25; alm=1/12; eta=.5; gas=atan(2*eta*alm); e=180/pi; h0=1; 
un=ones(1,N); Vs=sqrt(cos(gas)/alm); un1=ones(1,N-1); V0=1.1*Vs;
p0=[3*un -.04*un1 23]; lb=[2*un -.05*un1 22]; ub=[V0*un 0*un1 24];
optn=optimset('display','iter');
p=fmincon('glid_f',p0,[],[],[],[],lb,ub,'glid_c',optn,N,h0,V0); 
[f,al,x,h]=glid_f(p,N,h0,V0); V=[V0 p(1:N)]; ga=[0 p(N+1:2*N-1) 0]; 
xb=(x(2:N+1)+x(1:N))/2; x2=x(N+1); V2=V(N+1); xf=-f; Vf=1/sqrt(3*alm);
Ef=Vf^2/2; E0=h0+V0^2/2; E1=h0+Vs^2/2; h1=h0+E0-E1; E2=Vs^2/2;
x1=(E0-E2)/(2*eta*alm); E1f=[E2:(Ef-E2)/20:Ef]; a=4*alm^2;
for i=21:-1:1,
 x1f(i)=x1+(1/(eta*a))*log((1+a*E2^2)/(1+a*E1f(i)^2));
end; V1f=sqrt(2*E1f); al1f=cos(gas)*V1f.^(-2); tf=p(2*N);
%
figure(1); clf; subplot(211), plot(x,h,x,h,'.'); hold on;
plot([x2 xf],[0 0],xf,0,'o',[x1 xf],[-.02 -.02],'--');
plot([.2 .2],[h0 h1],'--',[0 x1],[h1 0],'--');
hold off; ylabel('h/l'); grid; axis([0 72 -.1 2.4]);
text(12,1.7,'Energy State'); text(25,.7,'Mass Point');
text(42,.3,'State Constraint'); 
subplot(212), plot(x,V,x,V,'.',xf,Vf,'o'); hold on;
plot([.2 .2],[V0 Vs],'--',[0 x1],[Vs Vs],'--');
plot(x1f,V1f); hold off; grid; axis([0 72 0 4]);
xlabel('x/l'); ylabel('V/\sqrt{gl}');
text(5,2.6,'V_{opt}');
print -deps2 \book_do\figures\f09_13
%
c=180/pi;
figure(2); clf; subplot(211), plot(xb,c*al,xb,c*al,'.');
hold on; plot(xf,3*c*alm,'o',x1f,c*al1f,'--');
plot([0 x1],c*alm*[1 1],'--'); hold off; grid;
axis([0 72 0 15]); ylabel('\alpha (deg)');
text(5,7,'\alpha_{opt}'); text(58,13.5,'\alpha_{max}'); 
subplot(212), plot(x,c*ga,x,c*ga,'.'); hold on;
plot([x2 xf],[0 0],xf,0,'o'); grid; axis([0 72 -5 1]);
plot([0 x1],-c*gas*[1 1],'--',[.2 .2],[0 -c*gas],'--');
plot(x1*[1 1],[-c*gas 0],'--',[x1 xf],-.05*[1 1],'--');
hold off; ylabel('\gamma (deg)'); xlabel('x/l');
text(3,-3.5,'\gamma_{opt}');
print -deps2 \book_do\figures\f09_14
%
figure(3); clf; plot(V,h,V,h,'.',[Vf V2],[0 0]); hold on;
plot(Vf,0,'o',V0,h0,'o',[Vf Vs],[-.01 -.01],'--' );
plot([Vs Vs],[0 h1],'--',[V0 Vs],[h0 h1],'--');
hold off; xlabel('V/sqrt(gl)'); ylabel('h/l');
grid; axis([0 4.5 -.1 2.4]);
text(3.8,1.75,'Zoom');  text(3.8,1.55,'Climb');
text(3.05,1.25,'V_{opt}');
print -deps2 \book_do\figures\f09_15
