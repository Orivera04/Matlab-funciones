% INVERSA
%
%
% B=INVERSA(A)
%
% Devuelve en B la inversa de A. B es calculada
% mediante la aplicacion del metodo de Gauss con 
% pivotaje parcial ficticio para n sistemas que
% permiten calcular las columnas de A
% 
% Version vectorizada
%
% Extraido del texto:
%  
%   "Matlab en cinco lecciones de numerico" 
%    por V. Dominguez y M.L. Rapun.
% 
% Más informacion en 
%
%   http://www.unavarra.es/personal/victor_dominguez

function x = inversa(a)

n=length(a);
b=eye(n);  % b es la identidad
p=1:n;     

% transformacion del sistema en uno triangular
for i=1:n-1
    [m,r]=max(abs(a(i:n,i))); r=r+i-1;
    p([i r])=p([r i]);  % pivotaje
    for k=i+1:n
        l=a(p(k),i)/a(p(i),i);
        a(p(k),i+1:n)=a(p(k),i+1:n)-l*a(p(i),i+1:n);
        b(p(k),:)=b(p(k),:)-l*b(p(i),:);
    end
    a(p(i+1:n),i)=0;
end 

% resolucion de los sistemas triangulares
x=zeros(n); 
for i=n:-1:1
    x(i,:)=(b(p(i),:)-a(p(i),i+1:n)*x(i+1:n,:))/a(p(i),i);
end

return
