%Familia de parábolas y=a^2-x^2
x=-5:0.1:5;
a=1:5;
[xx, aa] = meshgrid(x, a);
y=aa.^2-xx.^2;
plot(x,y)