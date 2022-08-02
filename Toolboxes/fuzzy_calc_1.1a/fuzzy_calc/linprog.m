function linprog(A,B,C)
% function linprog(A,B,C)
% solves fuzzy linear programming problems
% see the CD or the book for details, 
% section fuzzy linear programming
% Example input data are given in linprogsample.m
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

s=solve_fls(A,B); 

Lowi=s.low;

for i=1:length(Lowi)
        z(i)=0;
    for j=1:length(C)
        z(i)=z(i)+C(j)*Lowi(i,j);
    end
end

[x,index]=min(z);

solution=Lowi(index,:)

for i=1:length(Lowi)
        if x==z(i)
            disp([num2str(Lowi(i,:))])
        end
end
