
% Genera a matriz sparse de un problema de elementos
% y un vector independiente  b
%
% UTILIZA LA TOOLBOX DE ECUACIONES EN DERIVADAS PARCIALES

[p,e,t]=initmesh('lshapeg','Hmax',0.25);
n=-1;
while n>5 | n< 0
    n=input('Introduce  el número de refinamientos (n<6)   ');
end
for j=1:n
    [p,e,t]=refinemesh('lshapeg',p,e,t);
end
[a,b]=assempde('lshapeb',p,e,t,1,-1,1);
p= symamd(a);

% reordenamiento!
a=a(p,p);
b=b(p);
   
spy(a)