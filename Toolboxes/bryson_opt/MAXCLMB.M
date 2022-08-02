function f=maxclmb(p,T,flg)
% Subroutine for p1_2_11; finding max climb angle (flg=1) & 
% max climb rate (flg=2); p=[V alpha gamma]; 10/96, 3/25/02
%
V=p(1); al=p(2); ga=p(3); alm=1/12; eta=.5; ep=2*pi/180;
ca=cos(ga); sa=sin(ga); co=cos(al+ep); si=sin(al+ep);
f(1)=sa-T*co+eta*V^2*(al^2+alm^2);
f(2)=ca-T*si-V^2*al;
if flg==1,
 f(3)=eta*V^2*(al^2-alm^2)-T*(eta*(al^2+alm^2)*co-al*si);
elseif flg==2,
 A=[V*ca     0                    sa; 
    ca  T*si+2*eta*V^2*al  2*eta*V*(al^2+alm^2); 
    sa  T*co+V^2                 2*V*al       ];
 f(3)=det(A);
end