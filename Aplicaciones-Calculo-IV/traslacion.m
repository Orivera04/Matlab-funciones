 %Traslaci�n de par�bola sobre eje x
 %Gr�fica de la 1a par�bola
 x=-2:0.1:2;
 y=x.^2;
 plot(x,y);
 hold on;
 %Gr�fica de la 2a par�bola.
 x=x+1;
 y=(x-1).^2;
 plot(x,y,'r');
 legend('y=x^2','y=(x-1)^2');