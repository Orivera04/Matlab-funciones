function [f1,f2]=dvdpctd(ga,s,dt,t,flg)                            
% Subroutine for Pbs. 3.2.12, 3.5.12; DVDP for max range w.% gravity,
% thrust, drag, & spec. yf; s=[v x y]'; ga=ctrl; t in sqrt(l/g), v in
% sqrt(gl), a in g, (x,y) in l;                          5/97, 2/3/98          
%
global a yf; s=real(s); v=s(1); x=s(2); y=s(3); co=cos(ga);
si=sin(ga); b=sqrt(a-si); g=atanh(v/b); g1=dt*b+g;
cg=cosh(g); cg1=cosh(g1); tg=tanh(g); tg1=tanh(g1);
bg=-co/(2*b); gv=b/(b^2-v^2); gg=-v*bg/(b^2-v^2);
if flg==1,
 f1=[b*tg1; x+co*log(cg1/cg); y+si*log(cg1/cg)];
elseif flg==2,
   f1=[x; y-yf]; f2=[0 1 0; 0 0 1];                     
elseif flg==3,
 f1=[gv*b/(cg1)^2 0 0; gv*co*(tg1-tg) 1 0;...
     gv*si*(tg1-tg) 0 1];                  
 f2=[bg*tg1+b*(bg*dt+gg)/(cg1)^2;...
    -si*log(cg1/cg)+co*((bg*dt+gg)*tg1-gg*tg);...
     co*log(cg1/cg)+si*((bg*dt+gg)*tg1-gg*tg)];          
end


