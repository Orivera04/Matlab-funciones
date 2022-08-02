function yp=maxalte(t,y)        	       
% Subroutine for Pb 3.6.25f,b; max altitude climbing turn for 727  
% with specified (Vf,psf) using FOPCF or FOPCB; s=[V ga ps h x y]';
% u=[al sg]'; th=thrust, W=weight, S=ref. area, g=grav. force per
% unit mass; rho=air density; lc=2W/(g*rho*S); (h,x,y) in lc,
% V in sqrt(g*lc), (thrust,drag,lift) in W, t in  sqrt(lc/g);
%                                                     9/97, 2/5/98 		 
%
V=y(1); ga=y(2); ps=y(3); cga=cos(ga); sga=sin(ga); lv=y(7);
lg=y(8); lp=y(9); lh=y(10); lx=y(11); ly=y(12); z1=pi/180;   
la=[lv lg lp lh lx ly]'; al1=12*z1; cp=cos(ps); sp=sin(ps);
a0=.2476;  a1=-.04312; a2=.008392; th=a0+a1*V+a2*V^2;
b0=.07351; b1=-.08617; b2=1.996; c0=.1667; c1=6.231;    
sg=atan(lp/(cga*lg)); cs=cos(sg); ss=sin(sg); al=8*z1; z=1;
while abs(z)>1e-7,
  ep=2*pi/180; ca=cos(al+ep); sa=sin(al+ep);
  if al<al1, c2=0; else c2=-21.65; end
  cda=b1+2*b2*al; cla=c1+2*c2*(al-al1);
  z=lv*(-th*sa-V^2*cda)+(lg*cs+lp*ss/cga)*(th*ca+cla)/V;
  za=lv*(-th*ca-V^2*2*b2)+(lg*cs+lp*ss/cga)*(-th*sa+2*c2)/V;
  al=al-z/za;
end
cd=b0+b1*al+b2*al^2; cl=c0+c1*al+c2*(al-al1)^2; thv=a1+2*a2*V;
f1=[th*ca-cd*V^2-sga; (th*sa/V+cl*V)*cs-cga/V; ...
   (th*sa/V+cl*V)*ss/cga; V*sga; V*cga*cp; V*cga*sp];
fs=[thv*ca-2*cd*V                      -cga  0 0 0 0; ... 
   cs*(thv*sa/V-th*sa/V^2+cl)+cga/V^2  sga/V 0 0 0 0; ...
  (ss/cga)*(thv*sa/V-th*sa/V^2+cl) ...
             (sga*ss/(cga^2))*(th*sa/V+cl*V) 0 0 0 0; ...
  sga V*cga 0 0 0 0; ... 
  cga*cp -V*sga*cp -V*cga*sp 0 0 0; ... 
  cga*sp -V*sga*sp  V*cga*cp 0 0 0]; 
yp=[f1; -fs'*la];
      
      
   	 	 