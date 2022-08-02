%Dibuja la interseccion de un cono y una esfera
hold on;
esfera; %dibuja una esfera de radio=1,pide n
[x,y]=meshgrid(-1:.1:1,-1:.1:1);
w=sqrt(x.^2+y.^2);
surf(x,y,w); %ya están dibujadas cono y esfera
cilindrotrans%dibuja un cilindro, pide altura,radio,centro.