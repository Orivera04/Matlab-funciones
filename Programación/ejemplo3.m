f=inline('x^2+y^2','x','y');
h=input('De el valor de h: ');
x=0:h:1;
y=0:h:1;
suma=0;
for i=1:1/h
    for j=1:1/h
        suma=suma + (f(x(i),y(j))*h^2);
    end
end
sumatotal=suma

