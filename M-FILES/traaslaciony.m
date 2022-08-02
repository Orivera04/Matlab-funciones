%Traslación de parábola sobre eje y
 %Gráfica de la 1a parábola
 x=-2:0.1:2;
 y=x.^2;
 plot(x,y);
 hold on;
 %Gráfica de la 2a parábola.
 y=y+1;
 plot(x,y,'r');
 axis square;
 grid on;
 legend('y=x^2','y=x^2+1');
 