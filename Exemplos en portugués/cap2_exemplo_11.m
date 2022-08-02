echo on
% Arquivo: cap2_exemplo_11.m
% Exemplos do item 2.4.4: Struct
% Cria struct com 1 elemento
s=struct('Nome',{'Dolar Comercial'},'Iden',{'DOL'},'Valor',{3.19}) 
% Cria vetor de struct
s(2).Nome='Ouro 250g';
s(2).Iden='OZ1';
s(2).Valor=39.65;
s(2)
% nome dos campos
campos=fieldnames(s)
