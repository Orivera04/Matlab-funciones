function multimonomios = produmon()
%Multiplicación de n monomios: (x-a1)^m1* (x-a1)^m2... (x-an)^mn

syms x;
p=input('Introduzca el producto indicado de monomios: ');
expand(p);
multimonomios=sym2poly(p);
end

