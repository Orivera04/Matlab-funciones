function yp=calgld(t,s,flag,lx,ly)
% Subroutine for p4_3_16; max time constant-altitude glide (P. Lu) with
% spec. (xf,yf,vf); s=[x y v ps]'; E=max L/D; om=2W/(rho*S*Vo^2*Cl1)
% where Cl1=Cl at max L/D; (x,y) in units of Vo^2/g, v in Vo, t in Vo/g;
% Vf=sqrt(om*Cl1/Clmax); Clmax=1.8*Cl1;   9/97, 2/98, 6/25/98
%
E=20; om=.23; x=s(1); y=s(2); v=s(3); ps=s(4); cp=cos(ps); sp=sin(ps);
C=1+v^4/om^2; lp=lx*y-ly*x; B=v^2*(lx*cos(ps)+ly*sin(ps))-v;
if abs(sqrt(C*lp/B))<1e-3, ts=lp*C/2*B;  
   else ts=(sign(B)*sqrt(B^2+C*lp^2)-B)/lp; end
yp=[v*cp; v*sp; -(v^2+om^2*(1+ts^2)/v^2)/(2*E*om); ts/v];
 