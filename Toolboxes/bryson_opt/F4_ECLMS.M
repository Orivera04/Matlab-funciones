function yp=f4_eclms(t,y)                             
% Subroutine for e04_4_4; F4H energy state approxmation w. time varying
% mass; s=[E W x]'; control=V; units lc (length), Vc (velocity), tc
% (time); (T,L,D,W) in Wo;                  5/7/94, 9/96, 2/98, 3/15/02
%
Wo=.9888*41998; c=1600; S=530; g=32.2; rho=.002378; lc=2*Wo/(g*rho*S);
Vc=sqrt(g*lc); tc=lc/Vc; c=c/tc;
%
% Finds V to maximize edot:
E=y(1); W=y(2); Vmin=3; Vmax=7; V=fminbnd('f4_edot',Vmin,Vmax,[],E,W);
if E>V^2/2, h=E-V^2/2; else h=0; V=sqrt(2*E); end;    % h>0 constraint
% 
% Atmos. model; a(h), rhor(h); comp. of Mach number:
ao=1116/Vc; hc=145820/lc; lam=4.269; h1=20860/lc; ht=36090/lc;
if h<ht, a=ao*(1-h/hc)^.5; rhor=(1-h/hc)^lam;
 elseif h>=ht, a=968.1/Vc; rhor=((1-ht/hc)^lam)*exp(-(h-ht)/h1);
end; M=V/a;
%     
% Aerodynamic model - cdo(M), ka(M), cla(M);
if M<1.15, cdo=.013+.0144*(1+tanh((M-.98)/.06));
   cla=3.44+1.0/(cosh((M-1)/.06))^2; ka=.54+.15*(1+tanh((M-.9)/.06));
else cdo=.013+.0144*(1+tanh(.17/.06))-.011*(M-1.15);
   cla=3.44+1.0/(cosh(.15/.06))^2-(.96/.63)*(M-1.15); 
   ka=.54+.15*(1+tanh((.25)/.06))+.14*(M-1.15);
end; 
% 
% Max thrust model - compute T(M,h):
Q=[ 30.21     -.668  -6.877   1.951   -.1512; ...
   -33.80     3.347  18.13   -5.865    .4757; ...
   100.80   -77.56    5.441   2.864   -.3355; ...
   -78.99   101.40  -30.28    3.236   -.1089; ...
    18.74   -31.60   12.04   -1.785    .09417];
h1=h*lc/1e4; T=[1 M M^2 M^3 M^4]*Q*[1 h1 h1^2 h1^3 h1^4]'; T=T*1000/Wo;  
%  
% Energy-state approx for alp & cd:
alp=W/(T+cla*rhor*V^2);	cd=cdo+ka*cla*alp^2; D=cd*rhor*V^2;
% 
% Output
yp=[V*(T-D)/W; -T/c; V];    
