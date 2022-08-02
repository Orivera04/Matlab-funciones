echo on
% Arquivo: cap2_exercicio_03.m
% CAPITULO 2 - Solucao do Exercicio 03
% Criar vetor para representar os salarios
salarios=[50 100 150]
% Criar vetor para representar as frequencias
freq=[30 60 10]
% Calcular a media ponderada
media = sum(salarios.*freq)/ sum(freq)
% Variancia
 variancia=sum((salarios-media).^2.*freq)/sum(freq)
% Desvio padrao
dp=sqrt(variancia)
