function [f1,f2,f3]=minteclm(u,s,t,flg)                 
% Subroutine for Pb. 4.5.25e; min tf to given (hf,psf) for 727 at sea
% level, using ENERGY-STATE aprox; s=[E,ps,x,y]'; E=h+V^2/2, psi=ps;
% u=[V,sg]'; V=velocity, sg=bank angle; h=altitude=E-V^2/2; alpha=al;
% th=thrust; W=weight; S=ref. area; g=grav. force/unit mass; 
% rho=air density; charac. length l=2W/(g*rho*S); (h,x,y) in l, V 
% in sqrt(g*l), (thrust,drag,lift) in W, t in sqrt(l/g); S=1560 ft^2;
% rho=.002203 slug/ft^3;		                        4/94, 3/29/02  
%
E=s(1); ps=s(2);  x=s(3); y=s(4); V=u(1); sg=u(2);
ep=2*pi/180; al1=12*pi/180;
ao=.2476;  a1=-.04312;  a2=.008392;
bo=.07351; b1=-.08617;  b2=1.996;   
co=.1667;  c1=6.231;    
if al<al1, c2=0; else c2=-21.65; end
th=ao+a1*V+a2*V^2; cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2;
ca=cos(al+ep); cga=cos(ga); cs=cos(sg); cp=cos(ps);  
sa=sin(al+ep); sga=sin(ga); ss=sin(sg); sp=sin(ps);
% 
if flg==1, 
 f1=[th*ca-cd*V^2/2-sga; (th*sa+cl*V^2/2)*cs/V-cga/V; ...
	    (th*sa+cl*V^2/2)*ss/(V*cga); V*sga; V*cga*cp; V*cga*sp];
 f2=0;
elseif flg==2,
 f1=[t; h-.68; V-.85; ps-pi/2];
 f2=[0 0 0 0 0 0; 0 0 0 1 0 0; 1 0 0 0 0 0; 0 0 1 0 0 0];
 f3=[1 0 0 0]';
elseif flg==3,
 f1=[ca*(a1+2*a2*V)-cd*V    -cga 0 0 0 0; ... 
   (cs/V)*(sa*(a1+2*a2*V)+cl*V)-(cs/V^2)*(th*sa+cl*V^2/2)+cga/V^2  
   sga/V 0 0 0 0; (ss/(V*cga))*(sa*(a1+2*a2*V)+cl*V)-(ss/(V^2*cga))...
   *(th*sa+cl*V^2/2) (sga*ss/(V*cga^2))*(th*sa+cl*V^2/2) 0 0 0 0; ...
   sga -V*cga 0 0 0 0; cga*cp -V*sga*cp -V*cga*sp 0 0 0; ... 
   cga*sp -V*sga*sp  V*cga*cp 0 0 0]; 
 f2=[-th*sa-V^2*(b1+2*b2*al)/2   0;  ...
   (th*ca+V^2*(c1+2*c2*(al-al1))/2)*cs/V      -(th*sa+cl*V^2/2)*ss/V; ...
   (th*ca+V^2*(c1+2*c2*(al-al1))/2)*ss/(V*cga) (th*sa+cl*V^2/2)*cs/(V*cga); ...
   0 0; 0 0; 0 0];
end