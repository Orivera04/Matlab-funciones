% CHOLESKY
%
% [L,U]=CHOLESKY(A)
%
% Calcula L triangular inferior tal que
% A=L*L'
%
% Extraido del texto:
%  
%   "Matlab en cinco lecciones de numerico" 
%    por V. Dominguez y M.L. Rapun.
% 
% Más informacion en 
%
%   http://www.unavarra.es/personal/victor_dominguez

function [l,u]=cholesky(a)

n=length(a);
l=a*0; 
for k=1:n
    l(k,k)=sqrt(a(k,k)-l(k,1:k-1)*l(k,1:k-1)');
    l(k+1:n,k)=(a(k+1:n,k)-...
                 l(k+1:n,1:k-1)*l(k,1:k-1)')/l(k,k);
end