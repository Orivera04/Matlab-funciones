function [A1,B1]=sortmat(A,B);
% function [A1,B1]=sortmat(A,B);
% Arrange the rows in the matrix A and Column B in descending order for 
% the elements of the column B
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

Rows=length(B);
Cols=length(A(1,:));
[B1,sort_ind]=sort(B);
B1=flipud(B1);
sort_ind=flipud(sort_ind);
for j=1:Cols;
    for i=1:Rows
        A1(i,j)=A(sort_ind(i),j);
    end;
end;
