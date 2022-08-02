%Programa para encontrar las intesrsecciones de una funci�n con el eje x

%Introduccci�n de la funci�n y el dominio de f
syms x;
f=input('la funci�n a graficar es: f(x)= ');
domf=input('El dominio de f es [a,b]= ');
%C�lculo de las intersecciones con el eje x
Inter=solve(f)
n=numel(Inter)

%Gr�fica de la funci�n y los interceptos con eje x

ezplot(f,domf);
hold on;
abscisas = double(Inter);
ordenadas = zeros(1,n);
plot(abscisas,ordenadas,'r*')
grid on
legend('funci�n','intersecciones con eje x')
%FIN
