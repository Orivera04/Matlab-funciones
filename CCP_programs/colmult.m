function B = colmult(A)
%COLMULT   Multiply a column of A by a (possibly zero) constant.
%          Column no. j and multiplier k are accepted as input.
%          Use in the form  colmult(A)

k=input('Enter multiplier ');
j=input('Enter column number ');
A(:,j)=k*A(:,j);
B=A;

