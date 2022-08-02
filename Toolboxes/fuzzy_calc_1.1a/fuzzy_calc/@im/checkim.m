function isim=checkim(A)
% Fuzzy inutitionistic matrix checking function.
% Returns 1 if A is intuitionistic matrix, 
% ( if all elememts of the matrix A are intuitionistic numbers 
% i.e. 0<=Am(i,j)+An(i,j)<=1 ) 
% otherwise 0.
% See also getnonim.m
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

isim=1;

ij=size(A);
for i=1:ij(1)
    for j=1:ij(2)
        if A.m(i,j)+A.n(i,j)>1
            isim=0;
        end
    end
end
