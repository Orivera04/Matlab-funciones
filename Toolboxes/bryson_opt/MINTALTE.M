function yp=mintalte(t,y)      
% Subroutine for Pb. 4.7.24f,b;                 2/95, 9/15/02  
%
V=y(1); ga=y(2); h=y(3); ep=2*pi/180; al1=12*pi/180; W=180000;
rho=.002202; g=32.2; S=1560; lc=2*W/(rho*g*S); Vc=sqrt(g*lc);
lv=y(4); lg=y(5); lh=y(6); la=[lv lg lh]';
ao=.2476; a1=-.04312; a2=.008392; th=ao+a1*V+a2*V^2; 
bo=.07351; b1=-.08617; b2=1.996; co=.1667; c1=6.231;
cg=cos(ga); sg=sin(ga); thv=a1+2*a2*V; al=10*pi/180; z=1;
while abs(z)>1e-7,
  if al<al1, c2=0; else c2=-21.65; end
  cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2;
  cda=b1+2*b2*al; cla=c1+2*c2*(al-al1);
  ca=cos(al+ep); sa=sin(al+ep);
  z=lv*(-th*sa-cda*V^2)+lg*(th*ca/V+cla*V);
  za=lv*(-th*ca-2*b2*V^2)+lg*(-th*sa/V+2*c2);
  al=al-z/za;
end
f=[th*ca-cd*V^2-sg; th*sa/V+cl*V-cg/V; V*sg];
fs=[thv*ca-2*cd*V -cg 0; thv*sa/V-th*sa/V^2+cg/V^2 sg/V 0;
     sg V*cg 0];
yp=[f; -fs'*la];  
     
     
	 
