function TG=trasla_hk(x,y,h,k)
%Traslaci�n de gr�fica y= f(x) en direcci�n (h,k).
 x1=x+h;
 y1=y+k;
 plot(x,y);
 hold on;
 plot(x1,y1,'r');
 

