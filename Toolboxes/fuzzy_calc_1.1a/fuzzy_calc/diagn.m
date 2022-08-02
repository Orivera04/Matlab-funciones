function s=diagn(A,B,xs,bs);
% function s=diagn(A,B,xs,bs);
% start diagnosis procedure, using relational matrix A
% sympoms vector B
% descriptor vector for the sympoms bs
% and descriptor vector for the causes xs
% For test example, see sewing_defects.m
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

disp([' input '])
for i=1:length(B)
    if B(i)>0
        disp(['b ' num2str(i) ' =  ' num2str(B(i)) '  ' bs(i).str]);
    end
end

s=solve_fls(A,B);
% s=fsdemo(A,B)

if s.exists
    % disply maximal solution
    disp(['max solution']);
    for i=1:length(s.Xgr(:))
        if s.Xgr(i)>0
            disp(['x ' num2str(i) ' =  ' num2str(s.Xgr(i)) '  ' xs(i).str]);
        end
    end
    
    % disply minimal solution(s)
    for j=1:length(s.low(:,1))
        disp(['min ' num2str(j) '-th solution']);
        for i=1:length(s.Xgr(:))
            if s.low(j,i)>0
                disp(['x ' num2str(i) ' =  ' num2str(s.low(j,i)) '  ' xs(i).str]);
            end
        end
    end
end

        