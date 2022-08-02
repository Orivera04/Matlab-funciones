 %Ejemplo de uso de areashade
 x = [0:.5:20]; y = sin(x);
 figure, plot(x,y,'o-'), hold on
 areashade(x,y,1/sqrt(2),'r')
 areashade(x,y,-1/sqrt(2),'b','h');
 plot(xlim,1/sqrt(2)*[1 1],'k')
 plot(xlim,-1/sqrt(2)*[1 1],'k')