function [pstres,pvecs]=prnstres(stress)
% [pstres,pvecs]=prnstres(stress)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes principal stresses
% and principal stress directions for a three-
% dimensional stress state.
%
% stress - a vector defining the stress 
%          components in the order 
%          [sxx,syy,szz,sxy,sxz,syz]
%
% pstres - the principal stresses arranged in 
%          ascending order
% pvecs  - the transformation matrix defining 
%          the orientation of the principal 
%          axis system.  The rows of this 
%          matrix define the surface normals to 
%          the planes on which the extremal
%          normal stresses act
%
% User m functions called:  none

s=stress(:)'; 
s=([s([1 4 5]); s([4 2 6]); s([5 6 3])]);
[pvecs,pstres]=eig(s); 
[pstres,k]=sort(diag(pstres));
pvecs=pvecs(:,k)'; 
if det(pvecs)<0, pvecs(3,:)=-pvecs(3,:); end