clc
clear
a='';
for i=1:4
        nombre=input('¿Cuál es el nombre?: ','s');
        a=strvcat(a,nombre);
end
disp(a);