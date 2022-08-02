function y = forsub(A,b)                  %last updated 1/17/96
%FORSUB    Perform forward substitution on a lower triangular
%          system Ax = b.  If A is not square, lower
%          triangular and nonsingular an error message is
%          displayed. In case of an error the solution returned is
%          all zeros.
%
%   Use in the form  ==> forsub(A,b)  <==
%   
%     By: David R. Hill, MATH DEPT, Temple University,
%         Philadelphia, Pa. 19122   Email: hill@math.temple.edu
if (size(A)==size(A') & all(all(A==tril(A))) ..
    & abs(prod(diag(A))) > eps)
    n=length(b);
    x=zeros(n,1);
    for j=1:n
       x(j)=(b(j)-A(j,:)*x)/A(j,j);
    end
    y=x;
else
    disp('Error in function forsub.')
    disp('Coefficient matrix not square,')
    disp('not lower triangular, or is singular.')
    y=0;
end
                   
                         



