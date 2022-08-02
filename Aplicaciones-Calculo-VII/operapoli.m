%Programa sobre opeaciones algebraicas con polinomios.
syms x t u
exp1=input('Introduzca el primer polinomio: ')
exp2=input('Introduzca el segundo polinomio: ')
n=menu('Seleccione la operación a realizar','suma','resta','multiplicación','división');
switch n
    case 1
        disp('El resultado es: exp1+exp2= ');
        pretty(exp1+exp2)
        
    case 2
        disp('El resultado es: exp1-exp2= ');
        pretty(exp1-exp2)
        
    case 3
        disp('El resultado es: exp1*exp2= ');
        pretty(expand(exp1*exp2))
         
    case 4
         p=sym2poly(exp1);
         q=sym2poly(exp2);
         [r,s]=deconv(p,q);
         t=poly2sym(r);
         u=poly2sym(s);
         disp('El resultado es: exp1/exp2= ');
         disp('cociente= ');
         pretty(t)
         disp('residuo= ');
         pretty(u)         
end