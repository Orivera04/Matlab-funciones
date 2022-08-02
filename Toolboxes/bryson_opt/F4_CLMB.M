function [f1,f2,f3]=f4_clmb(u,s,t,flg)         
% Subroutine for Ex. 4.5.3;                               5/94, 9/5/02
%
Wo=.9888*41998; c=1600; S=530; g=32.2; rho=.002378; lc=2*Wo/(g*rho*S);
Vc=sqrt(g*lc); tc=lc/Vc; c=c/tc; Vf=968.1/Vc; hf=(20000/.3048)/lc;                        
V=s(1); ga=s(2); h=s(3); m=s(4); alp=u;	cg=cos(ga); sg=sin(ga);
ca=cos(alp); sa=sin(alp);
%
% Atmos. model; a(h), rhor(h); comp. of Mach number:
ao=1116/Vc; hc=145820/lc; lam=4.269; ha=20860/lc; ht=36090/lc;
if h<ht, a=ao*(1-h/hc)^.5; rhor=(1-h/hc)^lam; 
   dadh=-(.5*ao/(1-h/hc)^.5)/hc; drhordh=-lam*(1-h/hc)^(lam-1)/hc;		
elseif h>=ht, a=968.1/Vc; rhor=((1-ht/hc)^lam)*exp(-(h-ht)/ha);
   dadh=0; drhordh=(-1/ha)*rhor;
end
M=V/a; dMdV=1/a; dMdh=-(V/a^2)*dadh;
%
% Aerodynamic model - cdo(M), ka(M), cla(M), & derivatives; 
if M<1.15, cdo=.013+.0144*(1+tanh((M-.98)/.06)); 
   dcdodM=(.0144/.06)/(cosh((M-.98)/.06))^2; 
   cla=3.44+1.0/(cosh((M-1)/.06))^2;
	dcladM=-(2/.06)*sinh((M-1)/.06)/(cosh((M-1)/.06))^3;
	ka=.54+.15*(1+tanh((M-.9)/.06));
	dkadM=(.15/.06)/(cosh((M-.9)/.06))^2;
else cdo=.013+.0144*(1+tanh(.17/.06))-.011*(M-1.15);
	dcdodM=-.011; cla=3.44+1.0/(cosh(.15/.06))^2-(.96/.63)*(M-1.15);
	dcladM=-.96/.63; ka=.54+.15*(1+tanh((.25)/.06))+.14*(M-1.15);
	dkadM=.14;
end;
dcladV=dcladM*dMdV; dcladh=dcladM*dMdh; cd=cdo+ka*cla*alp^2;
dcddM=dcdodM+(dkadM*cla+ka*dcladM)*alp^2; dcddV=dcddM*dMdV;
dcddh=dcddM*dMdh; dcddalp=2*ka*cla*alp; 
%   
% Max thrust model - compute T(M,h), dT/dM, dT/dh:
Q=[ 30.21     -.668  -6.877   1.951   -.1512; ...
   -33.80     3.347  18.13   -5.865    .4757; ...
   100.80   -77.56    5.441   2.864   -.3355; ...
   -78.99   101.40  -30.28    3.236   -.1089; ...
	 18.74   -31.60   12.04   -1.785    .09417];
h1=h*lc/1e4; W1=Wo/1000; 
T=[1 M M^2 M^3 M^4]*Q*[1 h1 h1^2 h1^3 h1^4]'/W1;  
dTdM=[0 1 2*M 3*M^2 4*M^3]*Q*[1 h1 h1^2 h1^3 h1^4]'/W1;
dTdh1=[1 M M^2 M^3 M^4]*Q*[0 1 2*h1 3*h1^2 4*h1^3]'/W1;
dTdV=dTdM*dMdV; dTdh=dTdh1*lc/1e4+dTdM*dMdh;
%
% Outputs:
if flg==1
    f1=[(T*ca-cd*rhor*V^2)/m-sg; ((T*sa+cla*rhor*V^2*alp)/m-cg)/V; ...
         V*sg; -T/c];
elseif flg==2
    f1=[t; V/Vf-1; 10*ga; h/hf-1];
    f2=[zeros(1,4); diag([1/Vf 10 1/hf]) zeros(3,1)];
    f3=[1 0 0 0]';				      
elseif flg==3
   a11=(dTdV*ca-rhor*(dcddV*V+2*cd)*V)/m;
   a13=(dTdh*ca-(drhordh*cd+rhor*dcddh)*V^2)/m;
   a21=(dTdV*sa/V-T*sa/V^2+(cla+dcladV*V)*rhor*alp)/m+cg/V^2;
   a23=(dTdh*sa/V+(dcladh*rhor+cla*drhordh)*V*alp)/m;
   a24=-(T*sa+cla*rhor*V^2*alp)/m^2;
   f1=[a11 -cg a13 -(T*ca-cd*rhor*V^2)/m^2; a21 sg/V a23 a24; ...
     sg V*cg 0 0; -dTdV/c 0 -dTdh/c 0];
   f2=[(-T*sa-rhor*dcddalp*V^2)/m; (T*ca/V+cla*rhor*V)/m; 0; 0];	
end

