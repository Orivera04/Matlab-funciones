function n = vecnorm3d(v)
%VECNORM3D compute norm of vector or of set of 3D vectors
%
%   n = vecnorm(V);
%   return norm of vector V.
%
%   When V is a Nx3 array, compute norm for each vector of the array.
%   Vector are given as rows. Result is then a [N*1] array.
%
%   NOTE : compute only euclidean norm.
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 21/02/2005.
%

%   HISTORY

n = sqrt(sum(v.*v, 2));
