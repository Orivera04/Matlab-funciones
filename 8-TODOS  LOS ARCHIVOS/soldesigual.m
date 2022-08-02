%Programa para resolver desigualdades de la forma:
%(x-a1)(x-a2)...(x-an) > 0 (>=,<, <=). Factores no repetidos

%1er caso lizq > 0
%Si uno o más factores son de la forma bx-ai, se divide ese factor entre b
%La nueva desigualdad es equivalente a la 1a.

%Ejemplo: resolver (x+2)*(x-1)*x-3)>0

%Introducir miembro izquierdo.

syms x;

%
%
%
%
%
%
%
%
nfac=input('Dar No. de factores lin. no repetidos del lado izquierdo: ')
Li=input('Introduzca el lado izquierdo de la desigualdad reducida: ');

pol=sym2poly(Li);
rad=roots(pol);
raices=sort(rad)
n=numel(raices)
if mod(nfac,2)==0
for i=2:2:n
    li=raices(i);
    ld=raices(i+1);
    disp(['(',num2str(li),',',num2str(ld),') es solución'])
end
else
  for i=1:2:n-1
    li=raices(i);
    ld=raices(i+1);
    disp(['(',num2str(li),',',num2str(ld),') es solución'])
end  
disp(['(',num2str(raices(n)),',',num2str(+inf),') es solución'])
end