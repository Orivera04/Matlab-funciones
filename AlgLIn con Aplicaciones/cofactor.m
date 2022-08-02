function val = cofactor(i,j,A)            %<<1/17/96   last updated>>
%COFACTOR Computes the (i,j)-cofactor of matrix A.
%         If A is not sqaure an error message is displayed.
%         *** This routine should only be used by students to
%         check cofactor computations.
%
%             Use in the form  ==>  cofactor(i,j,A)  <==
%
%     By: David R. Hill, MATH DEPT, Temple University,
%         Philadelphia, Pa. 19122   Email: hill@math.temple.edu

blk=setstr(219);
[m,n]=size(A);
if m ~= n,
   disp([[blk blk blk] ['Error: matrix is not square.']])
   return
end
%range check on i and j
if i==abs(i) & j==abs(j) & i==fix(i) & j==fix(j)
   disp(' ');
else
   disp([[blk blk blk] ['Error: indices not positive or not integer.']])
   return
end
if i>n | j>n | i==0 | j==0
   disp([[blk blk blk] ['Error: indices out of range.']])
   return
end
val = (-1)^(i+j)*det(A([1:i-1 i+1:n],[1:j-1 j+1:n]));

