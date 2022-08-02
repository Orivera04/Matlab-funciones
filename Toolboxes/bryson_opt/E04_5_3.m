% Script e04_5_3.m; min time-to-climb to 20 km, M=1, ga=0 for F4 A/C;
% V(0)=929 ft/sec, W(0)=Wo*.9888 (where climb begins);   12/94, 9/5/02
%
name='f4_clmb'; W=.9888*41998; g=32.2; rho=.002378; S=530; c=180/pi;  
lc=2*W/(g*rho*S); Vc=sqrt(g*lc); V0=929/Vc; h0=50/lc; 
u0=[   .632 .507 .324 .201 .148 .144 .166 .195 .224 .243 .247 .224 ...
  .173 .105 .057 .081 .164 .252 .314 .343 .341 .324 .298 .272 .249 ...
  .231 .219 .212 .207 .205 .206 .207 .209 .210 .212 .211 .211 .209 ...
  .205 .201 .197 .193 .193 .196 .207 .228 .260 .307 .366 .437 .510 ...
  .579 .634 .655 .634 .569 .467 .341 .195 .006 -.195 -.390]'/10;
tf=37.2187; N=length(u0)-1;                       % Converged u and tf
tu=tf*[0:1/N:1]'; s0=[V0 0 h0 .9888]'; tc=lc/Vc; k=3e-5; told=1e-4;
tols=1e-3; mxit=0;                                        
[t,u,s,tf,nu,la0]=fopt(name,tu,u0,tf,s0,k,told,tols,mxit);
V=s(:,1)*Vc/1000; ga=s(:,2); alp=c*u(:,1); h=(lc/1000)*s(:,3);
x=(lc/1000)*cumtrapz(t,s(:,1).*cos(ga)); t=t/tf;  
%
V1=[0:.1:2.4]; for i=1:13, for j=1:length(V1) 
h1(i,j)=i*10-V1(j)^2/(.0322*2); end; end      % Const. energy. curves
%
figure(1); clf; for i=1:13, plot(V1,h1(i,:),'r--'); hold on;
end; plot(V,h); grid; axis([0 2 0 70]); V0=.442; Vf=.9681;
hf=20/.3048; Vcl=.9294; plot(V0,0,'ro',Vcl,0,'ro',Vf,hf,'ro'); 
text(.25,52,'E = constant'); text(.24,2.5,'Initial point')
text(1.08,65,'Final point'); text(.65,7,'Begin Climb')
xlabel('V (kft/sec)'); ylabel('h (kft)')
% 
figure(2); clf;  plot(x,h); grid; axis([0 400 0 300])
xlabel('x (kft)'); ylabel('h (kft)')
%
figure(3); clf; subplot(211), plot(t,alp); grid; axis([0 1 -3 4])
ylabel('\alpha (deg)'); subplot(212), plot(t,c*ga); grid
axis([0 1 -20 40]); xlabel('t/t_f'); ylabel('\gamma (deg)')

