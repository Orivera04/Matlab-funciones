function B = colcomb(A)
%COLCOMB  Form a linear combination of two columns of matrix A.
%         New column j of A = t*col k  + col j
%         The values of t, j, and k are accepted as input.
%         Use in the form   colcomb(A).

t=input('Enter multiplier ');
k=input('Enter first column number ');
j=input('Enter number of column which changes ');
A(:,j)=t*A(:,k) + A(:,j);
B=A;


