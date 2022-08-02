function [A,B]=re2le(R,T)
% function [A,B]=re2le(R,T)
% converts Fuzzy Relational Equation to 
% Fuzzy Linear System of Equations
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.


Rcols=length(R(1,:));
Rrows=length(R(:,1));
Tcols=length(T(1,:));
Trows=length(T(:,1));
if Rrows~=Trows
    A=[]
    B=[]
    disp('error in matrix dimensions')
else
    A=zeros(Tcols*Rrows,Tcols*Rcols);
    
    for mden=1:Tcols        
        for i=1:Rrows
            for j=1:Rcols
                A((mden-1)*Rrows+i,(mden-1)*Rcols+j)=R(i,j);
            end
        end
        for i=1:Rrows
            B((mden-1)*Rrows+i)=T(i,mden);
        end
    end
    B=B'
end
