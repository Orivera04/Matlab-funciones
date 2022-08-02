function [stif,masmat]= ...
  assemble(x,y,id,jd,a,e,rho)
%
% [stif,masmat]=assemble(x,y,id,jd,a,e,rho)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function assembles the global 
% stiffness matrix and mass matrix for a 
% plane truss structure. The mass density of 
% each element equals unity.
%
% x,y   - nodal coordinate vectors
% id,jd - nodal indices of members
% a,e   - areas and elastic moduli of members
% rho   - mass per unit volume of members
%
% stif  - global stiffness matrix
% masmat- global mass matrix
%
% User m functions called: elmstf
%----------------------------------------------

numnod=length(x); numelm=length(a); 
id=id(:); jd=jd(:);
stif=zeros(2*numnod); masmat=stif;
ij=[2*id-1,2*id,2*jd-1,2*jd];
for k=1:numelm, kk=ij(k,:);
  [stfk,volmk]= ...
    elmstf(x,y,a(k),e(k),id(k),jd(k));
  stif(kk,kk)=stif(kk,kk)+stfk;  
  masmat(kk,kk)=masmat(kk,kk)+ ...
                rho(k)*volmk/2*eye(4,4); 
end
