function [f1,f2,f3,f4,f5]=climbx0s(al,s,t,flg)          
% Subroutine for Pb. p2_7_23b & 8.5.23b; max altitude gain of A/C w. 
% (Vf,gaf,xf) specified; s=[V ga h]'; h in l, V in sqrt(g*l), t in 
% sqrt(l/g), al in 1/eta, l=2m/(rho*S*Cla), alm=sqrt(Cdo/(eta*Cla)); 
% indpt. variable is horiz. distance 'x';                    8/10/02
%
alm=1/12; eta=1/2; T=.2; Vf=5; V=s(1); ga=s(2); h=s(3);
si=sin(ga); co=cos(ga); sv=2e2; sg=sv; b=al^2+alm^2;
if flg==1
   f1=[T/(V*co)-eta*b*V/co-si/(V*co) al/co-1/V^2 si/co]';
elseif flg==2
   f1=[h-sv*(V-Vf)^2/2-sg*ga^2/2]; 
   f2=[-sv*(V-Vf) -sg*ga 1];
   f3=diag([-sv -sg 0]);
elseif flg==3
   f1=[-T/(V^2*co)-eta*b/co+si/(V^2*co) ...
       si*T/(V*co^2)-V*eta*b*si/co^2-1/(V*co^2) 0; ...
       2/V^3 al*si/co^2 0; 0 1/co^2 0];
   f2=[-2*V*eta*al/co 1/co 0]';
   f3=[2*(T-si)/(V^3*co) (1-T*si-V^2*eta*b*si)/(V^2*co^2) 0; ...
       (1-T*si-V^2*eta*b*si)/(V^2*co^2) ((T-V^2*eta*b)*(1+si^2)...
       -2*si)/(V*co^3) 0; 0 0 0; -6/V^4 0 0; 0 al*(1+si^2)/...
       co^3 0; 0 0 0; 0 0 0; 0 2*si/co^3 0; 0 0 0];
   f4=[-2*eta*al/co 0 0; -2*V*eta*al*si/co^2 si/co^2 0; 0 0 0];
   f5=[-2*V*eta/co 0 0]';
end

