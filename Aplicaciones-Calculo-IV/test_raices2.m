%Programa para determinar si las raices encontradas de un polinomio 
%son exactas.

p=input('Introducir los coeficientes del polinomio: ')
%Calcular las raices del polinomio usando el comando roots.
r_aprox=roots(p)
%Verificar Si las raices  son exactas
n=numel(r_aprox)
for i=1:n
    test=polyval(p,r_aprox(i))
    if test==0
        r_aprox(i)
        disp('es exacta');
        disp('')
    else
        r_aprox(i)
        disp('es inexacta');
        disp('')
   
    end
    
end