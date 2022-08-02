% Script p3_6_25n.m; 727 max altitude climbing turn w. (Vf,psf) spec.
% using FOPCN; max hf ; s=[V ga ps h x y]'; u=[al sg]'; 3/94, 5/28/02
%
al0=[.1335 .1372 .1416  .1464  .1518  .1575  .1636 ...
     .1700 .1764 .1830  .1895  .1960  .2026  .2092 ...
     .2155 .2213 .2264  .2309  .2348  .2379  .2404 ...
     .2422 .2434 .2439  .2438  .2431  .2419  .2401 ...
     .2379 .2352 .2320  .2284  .2245  .2202  .2155 ...  
     .2104 .2051 .1995  .1936  .1875  .1811];
%al0=[.133 .142 .152 .164 .176 .190 .203 .216 .226 .235 .240 ...
%     .243 .244 .243 .240 .235 .228 .220 .210 .200 .188];
N=length(al0)-1; tf=2.4; nu0=[.3915 .0149]; s0=[1 0 0 0 0 0]';
p0=[al0 nu0]; name='maxaltn'; 
optn=optimset('Display','Iter','MaxIter',250); 
p=fsolve('fopcn',p0,optn,name,s0,tf);
[f,s,la0]=fopcn(p,name,s0,tf); c=180/pi; 
W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S);
Vc=sqrt(g*lc); tc=lc/Vc; t=tc*tf*[0:1/N:1]; sg=c*p(1:N+1);
al=12.1*ones(1,N+1); nu=p(N+2:N+3); V=Vc*s(1,:); h=lc*s(4,:);
x=lc*s(5,:); y=lc*s(6,:); N1=length(V);
%
figure(1); clf; plot3(x,y,h,x,y,h,'.'); grid;
view(-80,15); axis([0 5000 0 5000 0 3000]); hold on;
plot3(x,y,zeros(1,N1),'--'); hold off;
xlabel('x (ft)'); ylabel('y (ft)'); zlabel('h (ft)');
%
figure(2); clf; subplot(211), plot(t,al,t,al,'.',t,sg,t,sg,'.'); 
grid; hold on; plot([0 24],[29.5 29.5],'--');     % Energy-state
plot([0 24],[11.8 11.8],'--'); hold off; axis([0 25 -8 35]);     
text(12,17,'\alpha'); text(12,25,'\phi'); ylabel('deg');   
subplot(212), plot(t,h,t,h,'.'); grid; axis([0 25 0 1800]);
xlabel('Time'); ylabel('Altitude (ft)');
%
figure(3); clf; subplot(211); plot(V,h,V,h,'.');
grid; axis([180 360 0 1800]); hold on;
plot([280 280],[425 875],'--');             % Energy state 
Vo=1*Vc; dV=(Vo-280)/20; V1=[Vo:-dV:280];
for i=1:21, h1(i)=(Vo^2/2-V1(i)^2/2)/32.2; end;
plot(V1,h1,'--'); Vf=.6*Vc; dV=(280-Vf)/20; V1=[Vf:dV:280];
hf=1660; for i=1:21, h1(i)=hf+(Vf^2/2-V1(i)^2/2)/32.2; end;
plot(V1,h1,'--',Vo,0,'o',Vf,hf,'o'); hold off;
xlabel('Velocity (ft/sec)'); ylabel('Altitude (ft)');
subplot(212), plot(t,V,t,V,'.'); grid; ylabel('V'); 
xlabel('Time');
%
figure(4); clf; plot(x,y,x,y,'.'); grid; xlabel('x (ft)');
ylabel('y (ft)');
	
	