h=input('De el valor de h: ');
suma=0;
 x=linspace(1,5,101);
 y=x;
[X,Y]=meshgrid(x);
 f=X.^2+Y.^2;
 for i=1:81
    for j=1:81
     suma=suma + f(i,j)*h*h;
    end
 end 
 suma

 