%Traslaci�n de par�bola sobre eje y
 %Gr�fica de la 1a par�bola
 x=-2:0.1:2;
 y=x.^2;
 plot(x,y);
 hold on;
 %Gr�fica de la 2a par�bola.
 y=y+1;
 plot(x,y,'r');
 axis square;
 grid on;
 legend('y=x^2','y=x^2+1');
 