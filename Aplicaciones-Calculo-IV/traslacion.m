 %Traslación de parábola sobre eje x
 %Gráfica de la 1a parábola
 x=-2:0.1:2;
 y=x.^2;
 plot(x,y);
 hold on;
 %Gráfica de la 2a parábola.
 x=x+1;
 y=(x-1).^2;
 plot(x,y,'r');
 legend('y=x^2','y=(x-1)^2');