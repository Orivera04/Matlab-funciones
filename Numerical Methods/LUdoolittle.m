% LUDOOLITTLE
%
% [L,U]=LUDOOLITTLE(A)
%
% Calcula U triangular superior, L triangular 
% inferior con 1s en la diagona de forma que
% A=L*U
%
% Extraido del texto:
%  
%   "Matlab en cinco lecciones de numerico" 
%    por V. Dominguez y M.L. Rapun.
% 
% Más informacion en 
%
%   http://www.unavarra.es/personal/victor_dominguez

function [l,u]=LUdoolitle(a)

n=length(a);
l=a*0; u=a*0;
for k=1:n
    u(k,k:n)=a(k,k:n)-l(k,1:k-1)*u(1:k-1,k:n);
    l(k,k)=1;
    l(k+1:n,k)=(a(k+1:n,k)-l(k+1:n,1:k-1)*u(1:k-1,k))/u(k,k);
end