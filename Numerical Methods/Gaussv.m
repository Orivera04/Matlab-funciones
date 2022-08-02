% GAUSSV
%
%
% X=GAUSSV(A,B)
%
% Devuelve en X la solucion del sistema AX=B 
% con el metodo de Gauss sin pivotaje
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

function x = gaussv(a,b)

n=length(a);
% transformacion del sistema en uno triangular
for i=1:n-1
    for k=i+1:n
        l=a(k,i)/a(i,i);
        a(k,i+1:n)=a(k,i+1:n)-l*a(i,i+1:n);
        b(k)=b(k)-l*b(i);
    end
    a(i+1:n,i)=0;
end 

% resolucion del sistema triangular
x=zeros(n,1); % tambien vale x=b*0;
for i=n:-1:1
    x(i)=(b(i)-a(i,i+1:n)*x(i+1:n))/a(i,i);
end

return
