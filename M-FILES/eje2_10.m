%Ejercicio 2.10
for NH=2:25
    for n=1:NH
Po(n)=1+2*sum((sin(n.*pi/sqrt(19))).^2);
    end
end
Po'