%Soluciones de una ecuación polinomial
%Introducir la ecuación como una cadena de caracteres
clc;
ecua=input('Introduzca la ecuación ');
disp('Ecuación: ');
disp(ecua);
%Resolver la ecuación
soluciones=solve(ecua);
sol=double(soluciones);
%Obtener el No. de soluciones
numsol=numel(sol);
%Presentar las soluciones
disp(['Esta ecuación tiene ',int2str(numsol),' soluciones'])
for i=1:numsol
    disp(['x(',int2str(i),')= ',num2str(sol(i))])
end


