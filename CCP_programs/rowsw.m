function B=rowsw(A)
%ROWSW  Switch the position of a pair of rows in matrix A.
%       The rows to switch are accepted as input.
%   Use in the form ---> rowsw(A)  <---
%  (David Hill, Temple U.)

[n,m]=size(A);
j=input('Enter first row number ');
k=input('Enter second row number ');
temp=A(j,:);
A(j,:)=A(k,:);
A(k,:)=temp;
B=A;
