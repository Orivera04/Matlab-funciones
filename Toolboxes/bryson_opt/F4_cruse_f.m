function f=f4_cruse_f(p,flg)         
% Subroutine for p1_3_23;                          12/97, 3/22/02
%
S=530; rho=.002378; W=38000; sg=.29e-3; V=p(1); h=p(2); 
alp=p(3); eta=p(4); ca=cos(alp); sa=sin(alp); 
%
% Atmospheric model a(h) & rhor(h) for h <36 kft:
ao=1116; hc=145820; la=4.269; a=ao*(1-h/hc)^.5; rhor=(1-h/hc)^la; 
%
% Aerodynamic model cdo(M), cla(M), & ka(M) for M<1.15: 
M=V/a; cdo=.013+.0144*(1+tanh((M-.98)/.06));
cla=3.44+1.0/(cosh((M-1)/.06))^2;
ka=.54+.15*(1+tanh((M-.9)/.06)); cd=cdo+ka*cla*alp^2;
%   
% Max thrust in lb:
h1=h/10000;                  % Altitude in units of 10000 ft
Q=[ 30.21     -.668  -6.877   1.951   -.1512; ...
   -33.80     3.347  18.13   -5.865    .4757; ...
   100.80   -77.56    5.441   2.864   -.3355; ...
   -78.99   101.40  -30.28    3.236   -.1089; ...
    18.74   -31.60   12.04   -1.785    .09417];
T=1000*[1 M M^2 M^3 M^4]*Q*[1 h1 h1^2 h1^3 h1^4]';  
%
if flg==1, f=5280*sg*eta*T/V;    % Fuel rate (lb/mile)
 elseif flg==2, f=sg*eta*T;      % Fuel rate (lb/sec)
end   

