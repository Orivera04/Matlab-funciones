% Script f03_20.m; 727 climbing turn using FOPC; max hf with (Vf,psf)
% specified; s=[V ga ps h x y]'; u=[al sg]'; initial guess from Pb.
% 1.3.22, ga=6 deg, turn rate=3.73 deg/sec, V=280 ft/sec, al=11.8 deg,
% ph=29.5 deg --> tf=90/3.73=24.1 sec; energy-state soln. is zoom climb
% to (425 ft, V=280 ft/sec), climb at V=280 to 875 ft, then zoom climb
% to 1660 ft;                                             3/94, 7/16/02
%
W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S); Vc=sqrt(g*lc);
tc=lc/Vc; s0=[1 0 0 0 0 0]'; k=-1e-4; told=1e-5; tols=1e-4; mxit=2;
u0(:,1)=[.1335 .1372 .1416 .1464 .1518 .1575 .1636 .1700 .1764 .1830...
   .1895 .1960 .2026 .2092 .2155 .2213 .2264 .2309 .2348 .2379 .2404...
   .2422 .2434 .2439 .2438 .2431 .2419 .2401 .2379 .2352 .2320 .2284...
   .2245 .2202 .2155 .2104 .2051 .1995 .1936 .1875 .1811]';  c=180/pi;    
u0(:,2)=28*ones(41,1)/c; tf=24.1/tc; tu=tf*[0:1/40:1]'; 
name='maxalt'; [t,u,s]=fopc(name,tu,u0,tf,s0,k,told,tols,mxit);  
t=tc*t; c=180/pi; V=Vc*s(:,1); h=lc*s(:,4); x=lc*s(:,5);
y=lc*s(:,6); N1=length(V);
Vo=Vc; dV=(Vo-280)/20; V1=[Vo:-dV:280]; un=ones(1,21);
h1=(un*Vo^2/2-V1.^2/2)/g; Vf=.6*Vc; dV=(280-Vf)/20; V2=[Vf:dV:280];
hf=1660; h2=un*hf+(un*Vf^2/2-V2.^2/2)/g; 
%
figure(1); clf; plot3(x,y,h,x,y,zeros(1,N1)); grid; view(-80,15)  
axis(1e3*[0 5 0 4 0 3]); xlabel('x (ft)'); ylabel('y (ft)')
zlabel('h (ft)')
%
figure(2); clf; subplot(211), plot(t,c*u,[0 24],[29.5 29.5],...
   'r--',[0 24],[11.8 11.8],'r--'); grid; text(12,17,'\alpha')
text(12,25,'\phi'); ylabel('deg'); subplot(212), plot(t,h); grid
axis([0 25 -100 1800]); xlabel('Time'); ylabel('Altitude (ft)')
%
figure(3); clf; subplot(211); plot(V,h,[280 280],[425 875],'r--',...
   V1,h1,'r--',Vo,0,'o',Vf,hf,'o',V2,h2,'r--'); grid
axis([180 360 -100 1800]); xlabel('Velocity (ft/sec)')
ylabel('Altitude (ft)'); subplot(212), plot(t,V); grid
xlabel('Time'); ylabel('V (ft/sec)')
%
figure(4); clf; plot(x,y); grid; xlabel('x (ft)'); ylabel('y (ft)')

