function A1=getnonim(A)
% function A1=getnonim(A)
% Return new object A1, constructed as im,
% but constists with only elememts where the conditions for intuitionistic
% matrix is not satisfied -     Am(i,j)+An(i,j)>1 
% and zeros in all other places. 
% See also checkim.m  im.m
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

ij=size(A);
for i=1:ij(1)
    for j=1:ij(2)
        if A.m(i,j)+A.n(i,j)>1
            A1.n(i,j)=A.n(i,j);
            A1.m(i,j)=A.m(i,j);
        else
            A1.m(i,j)=0;
            A1.n(i,j)=0;
        end
    end
end
A1=im(A1.m,A1.n);