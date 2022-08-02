function v=crossprd(x,y)                       %last updated 1/26/96
%CROSSPRD  Compute the cross product of vectors x and y in 3-space.
%       The output is a vector orthogonal to both of the original
%       vectors x and y. The output is returned as a row matrix
%       with 3 components [v1 v2 v3] which is interpreted as
%
%                       v1*i + v2*j + v3*k
%
%       where i, j, and k are the unit vectors in the x, y, and z
%       directions respectively.
%
%       Use in the form   ==>   v = crossprd(x,y)   <==
%
%     By: David R. Hill, MATH DEPT, Temple University,
%         Philadelphia, Pa. 19122   Email: hill@math.temple.edu

[mx nx]=size(x);[my ny]=size(y);
blk=setstr(219);
er='Error in Cross: size of input vector is not appropriate.';
if mx*nx~=3 | my*ny~=3
   disp([blk blk blk er])
   return
end
v=[x(2)*y(3)-x(3)*y(2) x(3)*y(1)-x(1)*y(3) x(1)*y(2)-x(2)*y(1)];


