% Exercicios Propostos 01
function exercicios_propostos_01 ()
echo on
% Matriz a
a=[100 120; 200 180]

% Matriz c
c=[25 28;42 55]

% Matriz m1 = c*a
m1 = c*a

% Matriz m2 = a*c
m2 = a*c

% Matriz a
%Carro \ Mês	Jan	Fev
%Carro C1       100	120 
%Carro C2       200	180
%Carro C3        90 100
%Carro C4       300 290
a1=[90 100; 300 290]
a=[a; a1]

% Matriz c
%Peça \ Carro	C1  C2  C3  C4
%Peça P1        25	28  30  40
%Peça P2        42	55  50  35
c1=[30 40;50 35]
c=[c c1]

% Matriz c*a (Peças P1 e P2 em Jan e Fev)
% para os carros C1, C2, C3 e C3
c*a




