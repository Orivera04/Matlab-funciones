clc
s=sprintf('pi vaut <<%0.5f>> et e <<%0.5f>>\n', pi, exp(1))
s=sprintf('pi vaut <<%-10.5f>> et e <<%10.5f>>\n', pi, exp(1)) 
s=sprintf('pi vaut <<%0.5e>> et e <<%0.5e>>\n', pi, exp(1))
s=sprintf('imprimo %  \n')          
a = 1:5; s=[sprintf('%3d +',a)]; s(end)=[];s

