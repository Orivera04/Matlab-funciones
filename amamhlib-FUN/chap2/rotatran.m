function mat=rotatran(v)
%
% mat=rotatran(v)
% ~~~~~~~~~~~~~~~
% This function creates a rotation matrix based 
% on the columns of v.
%
% v   - a matrix having three rows and either
%       one or two columns which are used to
%       create an orthonormal triad [i,j,k]
%       returned in the columns of mat. The
%       third base vector k is defined as
%       v(:,1)/norm(v(:,1)). If v has two 
%       columns then, v(:,1) and v(:,2) define 
%       the xz plane with the direction of j 
%       defined by cross(v(:,1),v(:2)). If only 
%       v(:,1) is input, then v(:,2) is set 
%       to [1;0;0].
%
% mat - the matrix having columns containing 
%       the basis vectors [i,j,k]
%
% User m functions called: none
%----------------------------------------------

k=v(:,1)/norm(v(:,1)); 
if size(v,2)==2, p=v(:,2); else, p=[1;0;0]; end
j=cross(k,p); nj=norm(j); 
if nj~=0
  j=j/nj; mat=[cross(j,k),j,k];
else 
  mat=[[0;1;0],cross(k,[0;1;0]),k];
end   