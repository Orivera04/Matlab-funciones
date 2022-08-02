%Programa para obtener un polinomio que es el desarrollo de 
%un binomio de Newton
function polinom=binewton(p,n)
q=expand(p^n);
polinom=sym2poly(q);
end

