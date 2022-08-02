function [f1,f2,f3]=mintclm(u,s,t,flg)        
% Subroutine for p4_5_25 & p4_7_25n;                 2/97, 9/5/02   
%
Vf=.6; psf=pi/2; hf=.5084; c=pi/180; ep=2*c; al1=12*c; V=s(1); 
ga=s(2); ps=s(3); h=s(4); al=u(1); sg=u(2); 
ca=cos(al+ep); cga=cos(ga); cs=cos(sg); cp=cos(ps);
sa=sin(al+ep); sga=sin(ga); ss=sin(sg); sp=sin(ps);
a0=.2476;  a1=-.04312; a2=.008392; th=a0+a1*V+a2*V^2;
b0=.07351; b1=-.08617; b2=1.996; cd=b0+b1*al+b2*al^2;   
c0=.1667;  c1=6.231; if al<al1, c2=0; else c2=-21.65; end
cl=c0+c1*al+c2*(al-al1)^2; thv=a1+2*a2*V; cda=b1+2*b2*al;
cla=c1+2*c2*(al-al1); z3=zeros(1,3); z4=zeros(1,4);
if flg==1
   f1=[th*ca-cd*V^2-sga; (th*sa/V+cl*V)*cs-cga/V; ...
        (th*sa/V+cl*V)*ss/cga; V*sga];
elseif flg==2
   f1=[t; V-Vf; ps-psf; h-hf]; 
   f2=[z4; 1 z3; 0 0 1 0; z3 1];
   f3=[1 z3]';
elseif flg==3
   f1=[thv*ca-2*cd*V -cga 0 0; cs*(thv*sa/V-th*sa/V^2+cl)+cga/V^2 ...
      sga/V 0 0; (ss/cga)*(thv*sa/V-th*sa/V^2+cl) ...
      (sga*ss/(cga^2))*(th*sa/V+cl*V) 0 0; sga V*cga 0 0];
   f2=[-th*sa-cda*V^2 0; cs*(th*ca/V+cla*V) -ss*(th*sa/V+cl*V); ...
      (ss/cga)*(th*ca/V+cla*V) (cs/cga)*(th*sa/V+cl*V); 0 0]; 
end