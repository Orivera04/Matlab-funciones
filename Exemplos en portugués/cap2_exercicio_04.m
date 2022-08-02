echo on
% Aquivo: cap2_exercicio_04.m
% CAPITULO 2 - Solucao do Exercicio 04
% Circuito Eletrico

% Definicao das variaveis
V1=10;
V2=5;
R1=1;
R2=2;
R3=3;
R4=4;
R5=5;

% Criacao da matriz A
A=[(R1+R4) -R4 0;-R4 (R2+R4+R5) -R5;0 -R5 (R3+R5)]

% Criacao do vetor B
B=[V1;0;-V2]

% Posto de A = 3, o sistema tem solucao
rank(A)

% Determinante de A diferente de 0, o sistema tem solucao
det(A)

% Solucao do sistema linear A*X = B
X=inv(A)*B
X=A\B

% O vetor X contém os valores das três correntes: 
% X(1) = I1, X(2) = I2 e X(3) = I3. 
% Para calcular a potência, execute:
PT = V1 * X(1) - V2 * X(3)
