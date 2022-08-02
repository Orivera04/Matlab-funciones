% cap3_interpft_exemplo ()
echo on
% Pontos no plano
x=rand(1,20);
% 100 pontos de interpolacao
y=interpft(x,100);
% Visualizacao dos resultados
plot(linspace(1,100,20),x,':',...
    linspace(1,100,100),y)
legend('Pontos','Interpft',0)
