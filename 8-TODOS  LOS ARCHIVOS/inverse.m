function B = inverse(A)                      %last updated 9/24/93
%INVERSE  Compute the inverse of a matrix A by using the reduced
%         row echelon form applied to [A I]. If A is singular a
%         warning is given.
%
%         Use in the form   -->  B = inverse(A)  <--
%
%     By: David R. Hill, Math. Dept., Temple University,
%         Philadelphia, Pa. 19122
[m n]=size(A);
if m~=n,disp('>>>>>> Error: matrix is not square.')
        return
end

C=rref([A eye(size(A))]);
D=C(:,1:m);BB=C(:,m+1:2*m);
if(det(D)==0)
   disp('>>>>>> Error: Matrix is singular.')
else
   B=BB;
end

