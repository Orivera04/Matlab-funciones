function [x,gyhiba]=newton(f1,f2,x0,hiba,itmax)
% fuggveny az x(k+1) = x(k) -f1(x(k))/f2(x(k)) ,k=0,1,...
% iteracio kiszamitasara rekurziv hivassal
% a megoldando egyenlet f1(x) = 0,
% f2(x) az f1 fuggveny derivaltja
% x0 - az iteracio kezdeti erteke
% gyhiba - a ket utolsoo iteralt elterese egymastol
% esetunkben az egyik megallasi feltetel az abs(gyhiba)<hiba
% vagy az itmax rekurziv hivasszam tullepese
%
% © Molnarka Gy''oz''o 1998; program a Matlab programozasa c. reszhez

echo on
if itmax<1 return; end
itmax=itmax-1;
x=x0;
a1=feval(f1,x);
a2=feval(f2,x);
x=x0-a1/a2;
gyhiba=abs(x-x0);
if gyhiba < abs(hiba) return; else 
[x,gyhiba]=newton(f1,f2,x,hiba,itmax);
end