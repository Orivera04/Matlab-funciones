function rreal=reales_horner(p,val)
%Programa para encontrar polinomios para calcular raices
%reales aproximadas con n digitos.
n=numel(p);
res(1)=1;
for i=n:-1:2
    [coc,rest]=horner1(p,val);
    res(i)=rest;
    p=coc;
end
rreal=res
end