%Programa para encontrar las intesrsecciones de una función con el eje x

%Introduccción de la función y el dominio de f
syms x;
f=input('la función a graficar es: f(x)= ');
domf=input('El dominio de f es [a,b]= ');
%Cálculo de las intersecciones con el eje x
Inter=solve(f)
n=numel(Inter)

%Gráfica de la función y los interceptos con eje x

ezplot(f,domf);
hold on;
abscisas = double(Inter);
ordenadas = zeros(1,n);
plot(abscisas,ordenadas,'r*')
grid on
legend('función','intersecciones con eje x')
%FIN
