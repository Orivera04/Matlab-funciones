%Familia de parábolas y=(x-a)^2
x=-5:0.1:5;
a=1:5;
[xx,aa]=meshgrid(x,a);
y=(xx-aa).^2;
plot(x,y);
axis([-1 8 0  5])

