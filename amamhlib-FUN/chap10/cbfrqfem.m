function [wfem,modvecs,mm,kk]= ...
                     cbfrqfem(nelts,mas,len,ei)
%
% [wfem,modvecs,mm,kk]=
%                    cbfrqfem(nelts,mas,len,ei)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Determination of natural frequencies of a 
% uniform depth cantilever beam by the Finite 
% Element Method.
%
%  nelts   - number of elements in the beam
%  mas     - total beam mass
%  len     - total beam length
%  ei      - elastic modulus times moment 
%            of inertia
%  wfem    - dimensionless circular frequencies
%  modvecs - modal vector matrix
%  mm,kk   - reduced mass and stiffness 
%            matrices
%
% User m functions called:  none
%----------------------------------------------

if nargin==1, mas=1; len=1; ei=1; end
n=nelts; le=len/n; me=mas/n; 
c1=6/le^2; c2=3/le; c3=2*ei/le;

% element mass matrix
masselt=me/420* ...
        [   156,   22*le,     54,  -13*le
          22*le,  4*le^2,  13*le, -3*le^2
             54,   13*le,    156,  -22*le
         -13*le, -3*le^2, -22*le,  4*le^2];

% element stiffness matrix
stifelt=c3*[ c1,  c2,  -c1,  c2
             c2,   2,  -c2,   1
            -c1, -c2,   c1, -c2
             c2,   1,  -c2,   2];

ndof=2*(n+1); jj=0:3; 
mm=zeros(ndof);  kk=zeros(ndof);

% Assemble equations
for i=1:n
  j=2*i-1+jj; mm(j,j)=mm(j,j)+masselt;
  kk(j,j)=kk(j,j)+stifelt;
end

% Remove degrees of freedom for zero 
% deflection and zero slope at the left end.
mm=mm(3:ndof,3:ndof); kk=kk(3:ndof,3:ndof);

% Compute frequencies
if nargout ==1
  wfem=sqrt(sort(real(eig(mm\kk))));
else
  [modvecs,wfem]=eig(mm\kk); 
  [wfem,id]=sort(diag(wfem));
  wfem=sqrt(wfem); modvecs=modvecs(:,id);
end