function B = colsw(A)
%COLSW  Switch two columns in a matrix A.
%       The columns to switch are accepted as input.
%       Use in the form  colsw(A)

[n,m] = size(A);
j = input('Enter the first column number ');
k = input('Enter the second column number ');
temp = A(:,j);
A(:,j)=A(:,k);
A(:,k)=temp;
B=A;
