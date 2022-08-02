 %Traslación de circunferencia sobre eje x
 %Gráfica de la 1a circunferencia
 t=0:pi/20:2*pi;
 x=2*cos(t);
 y=2*sin(t);
 plot(x,y);
 hold on;
 %Gráfica de la 2a circunferencia.
 plot([0,0],[0,0],'+r');
 plot([0,1],[0,1],'ok');
 x=x+1;
 y=y+1;
 plot(x,y,'r');axis square; 
 %legend('x^2+y^2=4','(x-1)^2+(y-1)^2=4');