% Evaluacion de un polinomio en puntos dados por el usuario

n = input ('Grado del polinomio: ');

for j=n:-1:0
    fprintf(1,'Coeficiente de x^%d : ',j);
    coef(n-j+1)=input ('');
end

while 1
    x = input ('Punto a evaluar: ');
    if x == -999
       break;
   end
   fprintf(1,'p(%f) = %f\n',x,polyval(coef,x));
end
