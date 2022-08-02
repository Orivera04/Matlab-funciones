%Programa del metodo de biseccion
a=input('Dar el limite inferior a: ');
b=input('Dar el limite superior b: ');
f=input('Dar la funcion f(como cadena): ');
eps=input('Dar el valor de eps: ');
syms x;
fa=subs(f,x,a);
fb=subs(f,x,b);
if fa==0 & ~(fb==0) 
    disp('Hay una raiz en:');
    a
elseif fb==0 & ~(fa==0)
    disp('Hay una raiz en:');
    b
elseif fa==0 & fb==0
    disp('Hay una raiz en:');
    a
    disp('y otra en:');
    b
elseif fa*fb>0
    disp('No hay raices en [a,b],cambiar intervalo')
else 
    x0 = (a+b)/2;
    while b-a>eps
        fx0=subs(f,x,x0);
        if fx0*fb<0
            a=x0;
        else
            b=x0;
        end
        x0=(a+b)/2;
    end
    raiz=x0
end
        
    
