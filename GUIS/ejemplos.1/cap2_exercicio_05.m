echo on
% Arquivo: cap2_exercicio_05
% CAPITULO 2 - Solucao do Exercicio 5
% Criar grafico x * cos(2*x) entre [-2pi,2pi]
x = -2*pi:0.1:2*pi;
y = x .* cos(2*x) ;
figure
plot(x,y)
figure
plot(y)
figure
m=[y' (x.*sin(2*x))'];
plot(m)
figure
plot(x,y,'+r')
y1 = x .* cos(2*x) ;
y2 = x .* exp(x);
subplot(1,2,1)
plot(x,y1)
title('x*cos(2*x)')
subplot(1,2,2)
plot(x,y2)
title('x*exp(x)')
h=gcf;
print(h,'-djpeg90','exercicio5.jpg')