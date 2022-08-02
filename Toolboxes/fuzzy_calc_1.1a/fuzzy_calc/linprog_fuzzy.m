function linprog_fuzzy(A,B,C)
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

disp('Preliminary results:')
for i=1:length(Lowi)
    for j=1:length(C)
        zz(j)=min(C(j),Lowi(i,j));
    end
    disp('--------------------------------')
    disp('Solution of constraints system')
    Lowi(i,:)
    disp('Objective function value')
    z(i)=max(zz);
    z(i)
end

[x,index]=min(z);

solution=Lowi(index,:);
disp('Results:')
for i=1:length(Lowi)
        if x==z(i)
            disp('FLP Solution:')
            disp([num2str(Lowi(i,:))])
        end
end
