%Programa burbujas de jabon
clear, clf, hold off;
axis([0,1,0,1]);
axis('square');
%axis('off');
hold on;
plot([0,1,1,0,0],[0,0,1,1,0])
h=pi/10;
t=0:h:pi*2
xx=cos(t);
yy=sin(t);
for  n=1:40
    r = rand(1)*0.1;
    xc=rand(1);
    yc=rand(1);
    x=xx*r + xc;
    y=yy*r + yc;
    plot(x,y)
end
hold off