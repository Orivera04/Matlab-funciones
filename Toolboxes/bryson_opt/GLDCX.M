function [f1,f2]=gldcx(al,s,t,flg)           
% Subroutine for Pb. 3.4.22b; max final altitude of a glider with spec.
% (Vf,gaf,xf); s = [V,ga,h]'; h in l, V in sqrt(g*l), t in sqrt(l/g), al
% in 1/eta, l=2m/(rho*S*Cla), alm=sqrt(Cdo/(eta*Cla)); indpt. variable
% is 'x' instead of 't';                                   2/97, 6/21/98
%
alm=1/12; eta=1/2; V=s(1); ga=s(2); h=s(3); si=sin(ga); c=cos(ga); 
if flg==1, f1=[-eta*(al^2+alm^2)*V/c-si/(V*c); al/c-1/V^2; si/c];
elseif flg==2, f1=[h; V-4; ga];  f2=[0 0 1; 1 0 0; 0 1 0];
elseif flg==3, f1=[-eta*(al^2+alm^2)/c+si/(V^2*c)...
   -V*eta*(al^2+alm^2)*si/c^2-1/(V*c^2) 0; 2/V^3 al*si/c^2 0;...
   0 1/c^2 0]; f2=[-2*V*eta*al/c; 1/c; 0];
end

