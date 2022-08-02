function [f1,f2,f3]=mintalt(u,s,t,flg)      
% Subroutine for Pbs. 4.5.24, 24a and 4.7.24n;     2/95, 9/5/02  
%
V=s(1); ga=s(2); h=s(3); c=pi/180; ep=2*c; al1=12*c; W=180000;
rho=.002202; g=32.2; S=1560; lc=2*W/(rho*g*S); Vc=sqrt(g*lc);
cg=cos(ga); sg=sin(ga); Vf=420/Vc; hf=2000/lc; al=u;
ao=.2476; a1=-.04312; a2=.008392; th=ao+a1*V+a2*V^2; 
bo=.07351; b1=-.08617; b2=1.996; co=.1667; c1=6.231;
thv=a1+2*a2*V; if al<al1, c2=0; else c2=-21.65; end
cd=bo+b1*al+b2*al^2; cl=co+c1*al+c2*(al-al1)^2; cda=b1+2*b2*al;
cla=c1+2*c2*(al-al1); ca=cos(al+ep); sa=sin(al+ep);
if flg==1
    f1=[th*ca-cd*V^2-sg; th*sa/V+cl*V-cg/V; V*sg];
elseif flg==2
    f1=[t; V-Vf; ga; h-hf];
    f2=[0 0 0; eye(3)];
    f3=[1 0 0 0]';
elseif flg==3
    f1=[thv*ca-2*cd*V -cg 0; thv*sa/V-th*sa/V^2+cg/V^2 ...
        sg/V 0; sg V*cg 0];
    f2=[-th*sa-cda*V^2; th*ca/V+cla*V; 0];
end
     

          	 
