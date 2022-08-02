syms x;
p=input('de el polinomio ');
r=sym2poly(p);
raices=roots(r)
n=numel(raices);
j=1;
for i=1:n 
    if imag(raices(i))==0
        q(j)=real(raices(i));
    end
    j=j+1;
end
 ceros=sort(q)   
m=numel(ceros);
sumareas=0;
disp('dé los valores de a y b, donde a < min(raices), b > max(raices)');
a=input('deme el valor de a ');
while a >= min(raices)
    disp('introduzca un valor de a que sea menor que min(raices)')
    a=input('deme el valor de a ')
end
b=input('deme el valor de b ');
while b <= max(raices)
    disp('introduzca un valor de b que sea mayor que max(raices)')
    a=input('deme el valor de b ')
end
for k=1:m-1
    area=int(p,ceros(k),ceros(k+1));
    sumareas=sumareas + abs(area);
end
area0=abs(int(p,a,ceros(1)));
areau=abs(int(p,ceros(m),b));
area = sumareas + area0 + areau;
disp('El área bajo el polinomio es  ')
disp(area)