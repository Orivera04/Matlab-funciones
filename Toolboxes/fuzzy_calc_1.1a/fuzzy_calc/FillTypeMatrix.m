function [Coef]=FillTypeMatrix(A,B);
% function [Coef]=FillTypeMatrix(A,B);
% Fill matrix with S(mall),G(reater),E(qual) coefficients for the system A*X=B
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.
global Rows Cols;
for i=1:Rows;
    for j=1:Cols;
        if A(i,j)>B(i)
            Coef(i,j)='G';
        elseif A(i,j)==B(i)
            Coef(i,j)='E';
        else Coef(i,j)='S';
        end;
    end;
end;