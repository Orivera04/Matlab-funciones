%Soluciones de una ecuaci�n polinomial
%Introducir la ecuaci�n como una cadena de caracteres
clc;
ecua=input('Introduzca la ecuaci�n ');
disp('Ecuaci�n: ');
disp(ecua);
%Resolver la ecuaci�n
soluciones=solve(ecua);
sol=double(soluciones);
%Obtener el No. de soluciones
numsol=numel(sol);
%Presentar las soluciones
disp(['Esta ecuaci�n tiene ',int2str(numsol),' soluciones'])
for i=1:numsol
    disp(['x(',int2str(i),')= ',num2str(sol(i))])
end


