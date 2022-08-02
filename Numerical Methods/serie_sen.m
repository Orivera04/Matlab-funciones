clear suma;
n=input('deme el valor de n ');
x = input('deme el valor de x ');
suma= x;
for i=1:n
    clear dif;
    m=n+1;
    p=2*n+1;
    dif=(-1)^m*(x^p)/factorial(p);
    dif
    suma = suma + dif;
    suma
end;
suma
