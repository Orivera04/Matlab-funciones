function f=zrmt_f(p)
% Subroutine for p4_4_02; VDP for min time to a point with uc=Vy/h;
% s=[x y]' in units of h, t in units of h/V;            12/96, 9/13/98
%
global xf yf; t1=p(1); tf=p(2); t2=t1-tf; y=sqrt(1+t1^2)-sqrt(1+t2^2);
x=.5*(asinh(t1)-asinh(t2)+t2*sqrt(1+t2^2)-t1*sqrt(1+t1^2))+...
   tf*sqrt(1+t1^2); f=[x-xf y-yf];
       

       
       