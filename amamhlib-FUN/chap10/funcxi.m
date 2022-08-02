function [f,f2]=funcxi(a,b,n,type,xi)
%
% [f,f2]=funcxi(a,b,n,type,xi)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
xi=xi(:); nxi=length(xi); R=atanh(b/a);
if type==1, N=pi/R*(1/2:n); f=cos(xi*N); 
else, N=pi/R*(1:n); f=sin(xi*N); end
f2=-repmat(N.^2,nxi,1).*f; 