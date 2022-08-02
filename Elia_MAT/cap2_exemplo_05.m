echo on
% Arquivo: cap2_exemplo_05.m
% Exemplo: item 2.3.4
a=[1 2 3 4 5;6 7 8 9 10; 11 12 13 14 15];
% Indexacao padrao
a(2,4)
% Indexacao sequencial
a(7)
% Intervalo de indexacao
b=a(2,2:4)
c=a(:,3)
d=a(1,:)
e=a(2,2:end)
f=[ a(3) a(10); a(5) a(12)]
