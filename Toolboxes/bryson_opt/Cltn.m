function [L,f,Ly,fy,Lyy,fyy]=cltn(y)                           
% Subroutine for Pb. 1.3.22 & 1.5.22; min helix radius (flg=1) or max
% turn rate (flg=2) for 727 at sea level for given climb angle ga; 
% y=[V al sg]'; charac. length l=2W/(g*rho*S); V^2 in g*l, (T,D,L) in
% W=weight, r in l;    	                               10/96, 5/13/98  
%
global flg ga; V=y(1); al=y(2); sg=y(3); c=pi/180; ep=2*c; al1=12*c;
ca=cos(al+ep); sa=sin(al+ep); cs=cos(sg); ss=sin(sg); ts=tan(sg);
cg=cos(ga); sg=sin(ga);
ao=.2476;  a1=-.04312;  a2=.008392;
bo=.07351; b1=-.08617;  b2=1.996;   
co=.1667;  c1=6.231; if al<=al1, c2=0; else c2=-21.65; end
th=ao+a1*V+a2*V^2; cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2;
thv=a1+2*a2*V; cda=b1+2*b2*al; cla=c1+2*c2*(al-al1);
thvv=2*a2;     cdaa=2*b2;      claa=2*c2;
if flg==1,
 L=V^2*cg/ts;                                  	  % L=turn radius
 Ly=cg*[2*V/ts  0  -V^2/ss^2];
 Lyy=cg*[2/ts 0 -2*V/ss^2; 0 0 0; -2*V/ss^2 0 2*V^2*cs/ss^3];
elseif flg==2,
 L=ts/V;					                               % L=turn rate
 Ly=[-ts/V^2 0 1/(V*cs^2)];
 Lyy=[2*ts/V^3 0 -1/(V*cs)^2; 0 0 0; -1/(V*cs)^2  0  2*ss/(V*cs^3)];
end 
f=[th*ca-cd*V^2-sg; th*sa*cs+cl*V^2*cs-cg];     
fy=[thv*ca-2*V*cd -th*sa-V^2*cda 0; thv*sa*cs+2*cl*V*cs ...
    th*ca*cs+cla*V^2*cs -ss*(th*sa+cl*V^2)];
f1vv=thvv*ca-2*cd; f1va=-thv*sa-2*V*cda; f1aa=-th*ca-V^2*cdaa;
fyy=[f1vv f1va 0; f1va f1aa 0; 0 0 0];
f2vv=(thvv*sa+2*cl)*cs;     f2va=cs*(thv*ca+2*V*cla);
f2vs=-ss*(thv*sa+2*cl*V);   f2aa=cs*(-th*sa+claa*V^2); 
f2as=-ss*(th*ca+cla*V^2);   f2ss=-cs*(th*sa+cl*V^2);
fyy=[fyy; f2vv f2va f2vs; f2va f2aa f2as; f2vs f2as f2ss];







