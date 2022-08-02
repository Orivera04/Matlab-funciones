function AD = adjoint(A)       %<<1/17/96   last updated>>
%ADJOINT  Compute the classical adjoint of a square matrix A.
%         If A is not square an empty matrix is returned.
%         *** This routine should only be used by students to
%         check adjoint computations and should not be used as
%         part of a routine to compute inverses. See invert or inv.
%
%         Use in the form   ==>  adjoint(A)  <==
%
%     By: David R. Hill, MATH DEPT, Temple University,
%         Philadelphia, Pa. 19122   Email: hill@math.temple.edu

[m,n]=size(A);
AD=[];
if m ~= n, return, end
for ki=1:n
   for kj = 1:n
      AD(ki,kj) = (-1)^(ki+kj)*det(A([1:ki-1 ki+1:n],[1:kj-1 kj+1:n]));
   end
end
AD=AD';
  end
end
AD=AD';
