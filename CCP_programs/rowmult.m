function B=rowmult(A)
%ROWMULT   Multiply a row of matrix A by a (possibly zero) constant.
%          Row number j and multiplier k are accepted as
%          input.
%   Use in the form ---> rowmult(A)  <---
%    
%  (David Hill, Temple U. -- modified to accept zero multipliers)

k=input('enter multiplier ');
j=input('enter row number ');
A(j,:)=k*A(j,:);
B=A;
