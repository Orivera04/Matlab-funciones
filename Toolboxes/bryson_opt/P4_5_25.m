% Script p4_5_25.m; min time climbing turn of 727 with
% (Vf hf psf) specified; s=[V ga ps h]'; u=[al sg]'; 
%                                            12/96, 9/5/02
%
W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S);
Vc=sqrt(g*lc); tc=lc/Vc; c=180/pi; name='mintclm';
u0(:,1)=[.1335 .1372 .1416  .1464  .1518  .1575  .1636 ...
         .1700 .1764 .1830  .1895  .1960  .2026  .2092 ...
         .2155 .2213 .2264  .2309  .2348  .2379  .2404 ...
         .2422 .2434 .2439  .2438  .2431  .2419  .2401 ...
         .2379 .2352 .2320  .2284  .2245  .2202  .2155 ...  
         .2104 .2051 .1995  .1936  .1875  .1811]';
u0(:,2)=.48*ones(41,1); tf=2.38; tu=tf*[0:1/40:1]'; 
s0=[1 0 0 0]'; k=-1e-6; told=1e-5; tols=5e-5; mxit=50;
[t,u,s,tf,nu,la0]=fopt(name,tu,u0,tf,s0,k,told,tols,mxit);
N1=length(t); V=s(:,1); ga=s(:,2); ps=s(:,3); h=lc*s(:,4);
x=lc*cumtrapz(t,V.*cos(ga).*cos(ps)); 
y=lc*cumtrapz(t,V.*cos(ga).*sin(ps)); 
u=c*u; ps=c*ps; V=Vc*V; t1=tc*t; 
%
% Energy state approximation:
Vo=1*Vc; dV=(Vo-280)/20; V1=[Vo:-dV:280];
for i=1:21, h1(i)=(Vo^2/2-V1(i)^2/2)/32.2; end
Vf=.6*Vc; dV=(280-Vf)/20; V2=[Vf:dV:280]; hf=1660;
for i=1:21, h2(i)=hf+(Vf^2/2-V2(i)^2/2)/32.2; end
%
figure(1); clf; plot3(x,y,h,x,y,zeros(1,N1),'r--'); grid
view(-80,15); axis([0 6000 0 3500 0 3000]); xlabel('x (ft)')
ylabel('y (ft)'); zlabel('h (ft)')
%
figure(2); clf; subplot(211), plot(t1,u); grid; ylabel('deg')   
legend('Angle-of-attack \alpha','Bank angle \phi',2)
subplot(212), plot(t1,h); grid; axis([0 25 0 1800])
xlabel('Time (sec)'); ylabel('Altitude (ft)')
%
figure(3); clf; subplot(311); plot(V,h,[280 280],[425 875],...
   'r--',V1,h1,'r--',V2,h2,'r--',Vo,0,'ro',Vf,hf,'ro'); grid
axis([190 340 0 1800]); xlabel('Velocity (ft/sec)');
ylabel('Altitude (ft)'); subplot(312), plot(t1,V,tc*tf,...
    V(N1),'ro',0,Vo,'ro'); grid; ylabel('Velocity (ft/sec)')
axis([0 25 190 340])
subplot(313), plot(t1,ps,tc*tf,90,'ro',0,0,'ro'); grid 
ylabel('Turn angle \psi (deg)'); xlabel('Time (sec)')
%
figure(4); clf; plot(x,y); grid; xlabel('x (ft)')
ylabel('y (ft)'); axis([0 5500 0 5500])
	
	