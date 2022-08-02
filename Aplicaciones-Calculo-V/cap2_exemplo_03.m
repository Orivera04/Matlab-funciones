% Arquivo: cap2_exemplo_03.m
% Exemplos: operadores
echo on
a=[1 2;3 4]
b=[5 6;7 8]
% a + b
a+b
% a - b
a-b
% a * b (multiplicacao matricial)
a*b
% a .* b (multiplicacao escalar, elemento a elemento)
a.*b
% a / b (divisao matricial = a * inv(b))
a/b
% a ./ b (divisao escalar, elemento a elemento)
a./b
% a \ b (divisao matricial pela esquerda = inv(a) * b)
a\b
% a ^ 3 (potencia matricial = a*a*a)
a^3
% a .^ 3 (potencia escalar, elemento a elemento)
a.^b
% a' (matriz transposta)
a'
% regra de precedencia
a+b*a
(a+b)*a
