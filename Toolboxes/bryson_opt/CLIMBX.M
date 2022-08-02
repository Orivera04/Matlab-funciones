function [f1,f2]=climbx(al,s,t,flg)          
% Subroutine for Pb. 3.4.23b; max altitude gain of A/C w. (Vf,gaf,xf)
% specified; s=[V ga h]'; h in l, V in sqrt(g*l), t in sqrt(l/g), al in
% 1/eta, l=2m/(rho*S*Cla), alm=sqrt(Cdo/(eta*Cla)); indpt. variable is
% horizontal distance 'x';                                2/97, 7/19/02
%
alm=1/12; eta=1/2; T=.2; Vf=5; gaf=0; V=s(1); ga=s(2); h=s(3);
si=sin(ga); co=cos(ga); 
if flg==1
    f1=[T/(V*co)-eta*(al^2+alm^2)*V/co-si/(V*co); al/co-1/V^2; si/co];
elseif flg==2
    f1=[h; V-Vf; ga-gaf]; 
    f2=[0 0 1; 1 0 0; 0 1 0];
elseif flg==3
    f1=[-T/(V^2*co)-eta*(al^2+alm^2)/co+si/(V^2*co) ...
        si*T/(V*co^2)-V*eta*(al^2+alm^2)*si/co^2-1/(V*co^2) 0; ...
        2/V^3 al*si/co^2 0; 0 1/co^2 0]; 
    f2=[-2*V*eta*al/co 1/co 0]';
end

