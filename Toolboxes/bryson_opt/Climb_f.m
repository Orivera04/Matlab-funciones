function [f,Tmax,h,x,m,alp,ng]=climb_f(p,N,Vo,ho,Vf,hf)          
% Subroutine for Pb. 9.3.15; F4 min time to climb to M=1, h=20 km, ga=0,
% with h>=0, T=Tmax; (Vo,ho,gao,Vf,hf,gaf) specified; lc=2Wo/(g*rho*S); 
% m in mo, T in g*mo=Wo, V in sqrt(g*lc), t in sqrt(lc/g), (x,h) in lc;
% for use with FMINCON;                                   8/01, 3/18/02
%
% Aircraft parameters (F4 aircraft);          
Wo=41998; S=530; alpmax=15*pi/180; ep=3*pi/180; Nmax=7;    
%      
% Ref length lc, velocity Vc, time tc:                       
rho=.002378; gr=32.2; lc=2*Wo/(gr*rho*S); Vc=sqrt(gr*lc);
tc=lc/Vc; cf=1600/tc;
%     
% Atmospheric data:
ao=1116/Vc; hc=145820/lc; lm=4.269; ha=20860/lc; ht=36090/lc;
%
% Estimates of V(t), ga(t), tf:
V=[Vo p(1:N-1) Vf]; ga=[0 p(N:2*N-2) 0]; tf=p(2*N-1); dt=tf/N;
Vb=(V(2:N+1)+V(1:N))/2;              Vd=(V(2:N+1)-V(1:N))/dt;
gb=(ga(2:N+1)+ga(1:N))/2;            gd=(ga(2:N+1)-ga(1:N))/dt;
%            
% Eqns of motion:   
g=zeros(1,2*N+1); mb=1; h(1)=ho; x(1)=0; m(1)=1; 
for i=1:N,
 h(i+1)=h(i)+Vb(i)*sin(gb(i))*dt; hb=(h(i+1)+h(i))/2;
 x(i+1)=x(i)+Vb(i)*cos(gb(i))*dt;
 %  
 % Relative air density rhor and Mach number M:
 if hb<ht, a=ao*(1-hb/hc)^.5; rhor=(1-hb/hc)^lm;
 else a=968.1/Vc; rhor=((1-ht/hc)^lm)*exp(-(hb-ht)/ha);
 end; M=Vb(i)/a; Mn(i)=M;
 %
 % Aerodynamic model - cdo(M), ka(M), cla(M);   % F4H aircraft
 if M<1.15, cdo=.013+.0144*(1+tanh((M-.98)/.06));
            cla=3.44+1.0/(cosh((M-1)/.06))^2;
	         ka=.54+.15*(1+tanh((M-.9)/.06));
 else       cdo=.013+.0144*(1+tanh(.17/.06))-.011*(M-1.15);
            cla=3.44+1.0/(cosh(.15/.06))^2-(.96/.63)*(M-1.15);
            ka=.54+.15*(1+tanh((.25)/.06))+.14*(M-1.15);
 end
 %
 % Max thrust/weight - Tmax(M,h):        (J79 turbojet engine)
 Q=[ 30.21     -.668  -6.877   1.951   -.1512; ...
    -33.80     3.347  18.13   -5.865    .4757; ...
    100.80   -77.56    5.441   2.864   -.3355; ...
    -78.99   101.40  -30.28    3.236   -.1089; ...
     18.74   -31.60   12.04   -1.785    .09417];
 h1=hb*lc/1e4;    W1=Wo/1000;  
 Tmax(i)=[1 M M^2 M^3 M^4]*Q*[1 h1 h1^2 h1^3 h1^4]'/W1;
 %
 % ng, m, alp, cd:
 ng(i)=Vb(i)*gd(i)+cos(gb(i));
 m(i+1)=m(i)-dt*Tmax(i)/cf; mb=(m(i+1)+m(i))/2;
 alp(i)=(mb*ng(i)-Tmax(i)*ep)/(Tmax(i)+cla*rhor*Vb(i)^2);
 cd=cdo+ka*cla*alp(i)^2;      
end
%
% Perf. index 
f=tf; 

   