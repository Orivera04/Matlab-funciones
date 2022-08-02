%Grafica la interseccin de un cono y un cilindro
h = 1; %altura = 1
r = 1; %radio = 1
c=[0 0];%centro en [0 0]
cilindrofC(h,r,c);
hold on;
[x,y]=meshgrid(-1:.1:1,-1:.1:1);
[m,n]=size(x);
w1=ones(m,n);
w2=sqrt(x.^2+y.^2);
surf(x,y,w1);
surf(x,y,w2);
rotate3d
