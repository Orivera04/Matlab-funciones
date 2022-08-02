%Traslación en x
%Figura original
x=-2:0.1:2;
y=x.^2;
plot(x,y,'r');
hold on;
%Figura trasladada
xt=x+3;
yt=y;
plot(xt,yt,'b')

