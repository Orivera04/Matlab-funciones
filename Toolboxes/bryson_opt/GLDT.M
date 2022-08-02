function [f1,f2,f3]=gldt(al,s,t,flg) 
% Subroutine for p4_4_22; max tf for spec. (Vf,gaf,hf) for glider;
% s=[V,ga,h]'; h in l, V in sqrt(g*l), t in sqrt(l/g), l=2m/(rho*S*Cla),
% alm=sqrt(Cdo/(eta*Cla)); 				                    2/97, 6/26/98
%
alm=1/12; eta=.5; Vf=4; hf=-8.1723; V=s(1); ga=s(2); h=s(3); si=sin(ga);
c=cos(ga); 
if flg==1, f1=[-eta*(al^2+alm^2)*V^2-si; al*V-c/V; V*si];
elseif flg==2, f1=[t; V-Vf; ga; h-hf]; f2=[0 0 0; eye(3)];
	 f3=[1 0 0 0]';
elseif flg==3, f1=[-2*V*eta*(al^2+alm^2) -c  0; al+c/V^2 si/V 0; ...
    si V*c 0]; f2=[-2*V^2*eta*al; V; 0];
end

