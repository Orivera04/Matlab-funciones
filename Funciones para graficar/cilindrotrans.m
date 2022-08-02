%Dibuja cilindro transparente con pocas generatrices.
r=input('radio = ');
h=input('altura = ');
c=input('coordenadas del centro : ');
t=0:2*pi/30:2*pi;
n=length(t);
x0=c(1)+r*cos(t);
y0=c(2)+r*sin(t);
z0=zeros(1,n);
x1=x0;
y1=y0;
z1=h+ones(1,n);
plot3(x0,y0,z0);
hold on;
plot3(x1,y1,z1);
s=linspace(0,h,30);
for k=0:7
    x=(c(1)+r*cos(pi*k/4))*ones(1,30);
    y=(c(2)+r*sin(pi*k/4))*ones(1,30);
    z=s;
    plot3(x,y,z)
    hold on
end