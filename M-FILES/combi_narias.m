%Estructura de un programa para generar combinaciones n_arias
% c es el cardinal del conjunto C={1,2,3..., n}. N es el orden
% de las combinaciones. N=2: binarias, N=3: ternarias, etc.
%ESTRUCTURA DEL PROGRAMA: COPIAR Y PEGAR.
disp('%   Programa para generar combinaciones N-arias de un conjunto C');
N=input('%   Oden de las combinaciones: N=');
disp(['function a = combina_',num2str(N),'(c)']); 
disp('p=1;');
disp('%   Abrir N ciclos for anidados:');
disp(['for k1=   1 : c - ',num2str(N-1)]) 
for i=2:N
    disp(['for k',num2str(i),'=k',num2str(i-1),'+1 : c - ',num2str(N-i)]);
end
disp('%   Instrucciones dentro del ciclo anidado:'); 
for i=1:N
    disp(['a(p,',num2str(i),')=k',num2str(i),';']);
end
disp('p=p+1;');
disp('%   Cerrar los N ciclos for anidados');
for i=1:N
    disp('end')
end
disp('a');
