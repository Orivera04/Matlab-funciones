function [m,k]=cablemk(masses,lngths,gravty)
%
% [m,k]=cablemk(masses,lngths,gravty)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Form the mass and stiffness matrices for 
% the cable.
%
% masses     - vector of masses
% lngths     - vector of link lengths
% gravty     - gravity constant
% m,k        - mass and stiffness matrices
%
% User m functions called:  none.
%----------------------------------------------

m=diag(masses);
b=flipud(cumsum(flipud(masses(:))))* ...
  gravty./lngths;
n=length(masses); k=zeros(n,n); k(n,n)=b(n);
for i=1:n-1
  k(i,i)=b(i)+b(i+1); k(i,i+1)=-b(i+1);
  k(i+1,i)=k(i,i+1);
end