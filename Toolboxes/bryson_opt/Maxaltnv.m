   function [f1,f2]=maxaltnv(u,s,t,flg)
   % Subroutine for Pb 3.6.25v; max hf for 727 for specified (Vf,psf);
   % s=[V,ga,ps,h,x,y]'; u=al; sg=const., th=thrust, W=weight, S=ref. area,
   % g=grav. force per unit mass; rho=air density; charac. length lc=
   % 2W/(g*rho*S); (h,x,y) in lc, V in sqrt(g*lc), (thrust,drag,lift),
   % in W; t in sqrt(lc/g); W=180000 lb, S=1560 ft^2, rho=.002203
   % slug/ft^3;                                        3/94, 2/97, 9/13/97
   %
   Vf=.60; psf=pi/2; ep=2*pi/180; al1=12*pi/180; V=s(1); ga=s(2);
   ps=s(3); h=s(4); x=s(5); y=s(6); al=u(1); sg=u(2); 
   ca=cos(al+ep); cga=cos(ga); cs=cos(sg); cp=cos(ps);  
   sa=sin(al+ep); sga=sin(ga); ss=sin(sg); sp=sin(ps);
   a0=.2476;  a1=-.04312; a2=.008392; th=a0+a1*V+a2*V^2;
   b0=.07351; b1=-.08617; b2=1.996;   c0=.1667;  c1=6.231;    
   if al<al1, c2=0; else c2=-21.65; end
   cd=b0+b1*al+b2*al^2; cl=c0+c1*al+c2*(al-al1)^2;
   thv=a1+2*a2*V; cda=b1+2*b2*al; cla=c1+2*c2*(al-al1);
   if flg==1, 
    f1=[th*ca-cd*V^2-sga; (th*sa/V+cl*V)*cs-cga/V; ... 
        (th*sa/V+cl*V)*ss/cga; V*sga; V*cga*cp; V*cga*sp];
   elseif flg==2,
    f1=[h; V-Vf; ps-psf];
    f2=[0 0 0 1 0 0; 1 0 0 0 0 0; 0 0 1 0 0 0];
   elseif flg==3,
    f1=[thv*ca-2*cd*V                       -cga  0 0 0 0; ... 
	     cs*(thv*sa/V-th*sa/V^2+cl)+cga/V^2  sg/V 0 0 0 0; ...
	    (ss/cga)*(thv*sa/V-th*sa/V^2+cl) ...
	               (sga*ss/(cga^2))*(th*sa/V+cl*V) 0 0 0 0; ...
	     sga V*cga 0 0 0 0; ... 
	     cga*cp -V*sga*cp -V*cga*sp 0 0 0; ... 
	     cga*sp -V*sga*sp  V*cga*cp 0 0 0]; 
    f2(:,1)=[-th*sa-cda*V^2 cs*(th*ca/V+cla*V) ...
          (ss/cga)*(th*ca/V+cla*V) 0 0 0]';
    f2(:,2)=
       end