function yp=maxaltte(t,y)        	       
% Subroutine for Pb 4.6.25f,b; min time climbing turn for 727 with 
% specified (Vf,gaf,hf,psf,yf) using FOPTF;  s=[V,ga,ps,h,x,y]';
% u=[al,sg]'; th=thrust, W=weight, S=ref. area, g=grav. force per
% unit mass; rho=air density; lc=2W/(g*rho*S); (h,x,y) in lc,
% V in sqrt(g*lc), (thrust,drag,lift) in W, t in  sqrt(lc/g);
% W=180000 lb, S=1560 ft^2, rho=.002203 slug/ft^3;   8/97, 7/31/02 		 
%
V=y(1); ga=y(2); ps=y(3); cga=cos(ga); sga=sin(ga); lv=y(7);
lg=y(8); lp=y(9); lh=y(10); lx=y(11); ly=y(12); ep=2*pi/180;  
la=[lv lg lp lh lx ly]'; al1=12*pi/180; cp=cos(ps); sp=sin(ps);
ao=.2476; a1=-.04312; a2=.008392; th=ao+a1*V+a2*V^2;
bo=.07351; b1=-.08617; b2=1.996; co=.1667; c1=6.231;    
sg=atan2(lp,cga*lg); cs=cos(sg); ss=sin(sg); al=10*pi/180; z=1; 
while abs(z)>1e-6, ca=cos(al+ep); sa=sin(al+ep);
   if al<al1, c2=0; else c2=-21.65; end
     z=lv*(-th*sa-V^2*(b1+2*b2*al))...
            +(lg*cs+lp*ss/cga)*(th*ca+c1+2*c2*(al-al1))/V;
     zal=lv*(-th*ca-2*b2*V^2)-(lg*cs+lp*ss/cga)*(th*sa-2*c2)/V;
     al=al-z/zal;
   end   
 cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2;
 thv=a1+2*a2*V; cda=b1+2*b2*al; cla=c1+2*c2*(al-al1);
 f=[th*ca-cd*V^2-sga; (th*sa/V+cl*V)*cs-cga/V; ...
        (th*sa/V+cl*V)*ss/cga; V*sga; V*cga*cp; V*cga*sp];
 fs=[thv*ca-2*cd*V                       -cga  0 0 0 0; ... 
	 cs*(thv*sa/V-th*sa/V^2+cl)+cga/V^2  sga/V 0 0 0 0; ...
	 (ss/cga)*(thv*sa/V-th*sa/V^2+cl) ...
	           (sga*ss/(cga^2))*(th*sa/V+cl*V) 0 0 0 0; ...
	 sga -V*cga 0 0 0 0; ... 
	 cga*cp -V*sga*cp -V*cga*sp 0 0 0; ... 
	 cga*sp -V*sga*sp  V*cga*cp 0 0 0]; 
 yp=[f; -fs'*la];
   
   	 	 