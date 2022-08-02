function y = gschmidt(x,v)            %last updated 5/11/94
%GSCHMIDT  The Gram-Schmidt process on the columns in matrix 
%          x. The orthonormal basis appears in the columns of y
%          unless there is a second argument in which case y 
%          contains only an orthogonal basis. The second argument
%          can have any value.
%
%          Use in the form  ==> y = gschmidt(x)  <==  or
%                           ==> y = gschmidt(x,v)  <==
%
%  By: David R. Hill, MATH Department, Temple University
%      Philadelphia, Pa., 19122        Email: hill@math.temple.edu
%
[m,n]=size(x);
y=x(:,1);
for k = 2:n  % orthogonlization process
   z=0;
   for j=1:k-1
      p=y(:,j);
      z=z+((p'*x(:,k))/(p'*p))*p;
   end
   y=[y x(:,k)-z];
end
if nargin == 1
   for j=1:n, y(:,j) = y(:,j)/norm(y(:,j));end % normalizing
end
