%Programa para realizar operaciones con matrices
%Se introducen dos matrices A y B y un escalar p y se pide realizar las
%operaciones: A+B,  A-B, A*B, p*A, p*B. Si A y B no son  conformes bajo el
%producto de matrices se manda a imprimir un mensaje de error.  
%Introducción de las matrices A , B y el escalar p.

A=input('Introduzca la matriz A:  ')
B=input('Introduzca la matriz B:  ')
P=input('Introduzca el escalar p: ')
%Obtener el tamaño de cada matriz.
[m,n]=size(A)
[p,q]=size(B)
%Comprobar si son conformes bajo la suma, si lo son efectuar suma y resta;
%si no, mandar a imprimir un mensaje de error.
if [m,n]==[p,q]
    suma= A + B
    resta= A - B
else
    disp('No se puede calcular A+B ni A-B;las matrices A y B no son del mismo orden')
end
%Comprobar si son conformes bajo el producto de matrices,si lo son calcular
%el producto A*B,  si no, mandar a imprimir un mensaje de error.
if n==p 
   producto=A*B
else 
   disp('No se puede calcular A*B;A y B no son conformes bajo el producto de matrices')
end


%Efectuar los productos: p*A   y   p*B.
p_por_A = p*A
p_por_B = p*B
%Fin del programa
