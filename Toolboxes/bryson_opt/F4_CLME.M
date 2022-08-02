function yp=f4_clme(t,y)                                         
% Euler-Lagrange eqns. for F4H min time climb to 20 km, M=1, ga=0,
% w. time-varying mass; s=[V ga h m x]'; y=[s; lambda]; lengths in
% lc, time in tc; 					                  9/18/96, 2/18/97
%
Wo=.9888*41998; c=1600; S=530; g=32.2; rho=.002378;       % Parameters 
lc=2*Wo/(g*rho*S); Vc=sqrt(g*lc); tc=lc/Vc; c=c/tc;    % Charac. l,V,t   
Vf=968.1/Vc; hf=(20000/.3048)/lc;
V=y(1); ga=y(2); h=y(3); m=y(4); x=y(5); 
%
% Atmospheric model - a(h), rhor(h); computation of Mach number:
  ao=1116/Vc;  hc=145820/lc;  lam=4.269; ha=20860/lc;  ht=36090/lc;
  if h<ht,
    a=ao*(1-h/hc)^.5;                 rhor=(1-h/hc)^lam;
    dadh=-(.5*ao/(1-h/hc)^.5)/hc;     drhordh=-lam*(1-h/hc)^(lam-1)/hc;		
  elseif h>=ht,
    a=968.1/Vc;                   rhor=((1-ht/hc)^lam)*exp(-(h-ht)/ha);
    dadh=0;                       drhordh=(-1/ha)*rhor;
  end
  M=V/a;
    dMdV=1/a;  
    dMdh=-(V/a^2)*dadh;
%
% Aerodynamic model - cdo(M), ka(M), cla(M), & derivatives; 
  if M<1.15, cdo=.013+.0144*(1+tanh((M-.98)/.06));
              dcdodM=(.0144/.06)/(cosh((M-.98)/.06))^2;
             cla=3.44+1.0/(cosh((M-1)/.06))^2;
	      dcladM=-(2/.06)*sinh((M-1)/.06)/(cosh((M-1)/.06))^3;
             ka=.54+.15*(1+tanh((M-.9)/.06));
	      dkadM=(.15/.06)/(cosh((M-.9)/.06))^2;
    else     cdo=.013+.0144*(1+tanh(.17/.06))-.011*(M-1.15);
 	      dcdodM=-.011;
             cla=3.44+1.0/(cosh(.15/.06))^2-(.96/.63)*(M-1.15);
	      dcladM=-.96/.63;
             ka=.54+.15*(1+tanh((.25)/.06))+.14*(M-1.15);
	      dkadM=.14;
  end; 
    dcladV=dcladM*dMdV;   
    dcladh=dcladM*dMdh;
    
% Max thrust model - compute T(M,h), dT/dM, dT/dh:
  Q=[ 30.21     -.668  -6.877   1.951   -.1512; ...
     -33.80     3.347  18.13   -5.865    .4757; ...
     100.80   -77.56    5.441   2.864   -.3355; ...
     -78.99   101.40  -30.28    3.236   -.1089; ...
      18.74   -31.60   12.04   -1.785    .09417];
  h1=h*lc/1e4;    W1=Wo/1000;  
  T=[1 M M^2 M^3 M^4]*Q*[1 h1 h1^2 h1^3 h1^4]'/W1;  
    dTdM=[0 1 2*M 3*M^2 4*M^3]*Q*[1 h1 h1^2 h1^3 h1^4]'/W1;
    dTdh1=[1 M M^2 M^3 M^4]*Q*[0 1 2*h1 3*h1^2 4*h1^3]'/W1;
  dTdV=dTdM*dMdV;
  dTdh=dTdh1*lc/1e4+dTdM*dMdh;
%
% Output:
  la=y([6:10]);
  alp=la(2)*(T/V+cla*rhor*V/m)/(la(1)*(T+rhor*2*ka*cla*V^2/m));
  cg=cos(ga);   sg=sin(ga);   ca=cos(alp);   sa=sin(alp);
  cd=cdo+ka*cla*alp^2;
    dcddM=dcdodM+(dkadM*cla+ka*dcladM)*alp^2;
    dcddV=dcddM*dMdV;
    dcddh=dcddM*dMdh;
  f=[(T*ca-cd*rhor*V^2)/m-sg; ((T*sa+cla*rhor*V^2*alp)/m-cg)/V; ...
          V*sg;  -T/c;  V*cg];
  fs=[(dTdV*ca-rhor*(dcddV*V+2*cd)*V)/m   -cg ...
             (dTdh*ca-(drhordh*cd+rhor*dcddh)*V^2)/m  ... 
             -(T*ca-cd*rhor*V^2)/m^2   0; ...  
        (dTdV*sa/V-T*sa/V^2+(cla+dcladV*V)*rhor*alp)/m+cg/V^2  sg/V ...
             (dTdh*sa/V+(dcladh*rhor+cla*drhordh)*V*alp)/m ...
             -(T*sa+cla*rhor*V^2*alp)/m^2   0; ...
        sg   V*cg  0  0  0; ...
        -dTdV/c 0 -dTdh/c 0 0; ...
        cg  -V*sg  0  0  0];				 
  yp=[f; -fs'*la];
