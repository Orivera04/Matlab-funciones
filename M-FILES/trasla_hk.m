function TG=trasla_hk(x,y,h,k)
%Traslación de gráfica y= f(x) en dirección (h,k).
 x1=x+h;
 y1=y+k;
 plot(x,y);
 hold on;
 plot(x1,y1,'r');
 

