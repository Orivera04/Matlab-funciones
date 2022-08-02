function B = rowcomb(A)
%ROWCOMB  Form a linear combination of rows of matrix A.
%         Row j of A = t*row k + row j.
%         The values of t,j, and k are accepted as input.
%   Use in the form ---> rowcomb(A)  <---
%    
%  (David Hill, Temple U.)

t=input('Enter multiplier ');
k=input('Enter first row number ');
j=input('Row number that changes ');
A(j,:)=t*A(k,:)+A(j,:);
B=A;
