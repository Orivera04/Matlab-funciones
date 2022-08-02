function [u,x,y]=modeshap(a,b,type,modemat,nxi,neta)
%
% [u,x,y]=modeshap(a,b,type,modemat,nxi,neta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if nargin<6, neta=81; end; if nargin<5, nxi=22; end
h=sqrt(a^2-b^2); r=atanh(b/a); x=[]; y=[];
xi=linspace(0,r,nxi); eta=linspace(-pi,pi,neta);
if nargout>1  
  [Xi,Eta]=meshgrid(xi,eta); z=h*cosh(Xi+i*Eta);
  x=real(z); y=imag(z);
end
[Neta,Nxi]=size(modemat); 
mateta=funceta(Neta,type,eta);
matxi=funcxi(a,b,Nxi,type,xi);
u=mateta*modemat*matxi';