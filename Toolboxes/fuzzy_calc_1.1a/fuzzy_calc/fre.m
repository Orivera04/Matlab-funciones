function [Xgr,low,sol]=fre(R,T);
% function [Xgr,low,sol]=fre(R,T);
% solves fuzzy relational equation R*S=T
% where R and T are given matrices
% and * here denote (max-min) composition
%
% If the system is consistent
% Xgr is the greatest (maximal) solution 
% low consists the low (minimal) solutions
% sol is a structure, of the corresponding FLSE
% see FillHelpMatrix or solve_fls for details
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.
%
[A,B]=re2le(R,T);

sol_=solve_fls(A,B);

switch sol_.exists
    case 1
        
        Qrows=length(R(1,:));
        Qcols=length(T(1,:));
        
      %  sol_.Xgr;
        for i=1:length(sol_.Xgr)
            if mod(i,Qrows)==0
                solrow=Qrows;
            else
                solrow=mod(i,Qrows);
            end
            Xgr(solrow,1+fix((i-1)/Qrows))=sol_.Xgr(i);
        end
        
        if any(fuzzy_maxmin(R,Xgr)-T)
            disp('ERROR in SOLUTION')
        end
        
        
        for Sol_Nr=1:sol_.sol_numb
            for i=1:length(sol_.Xgr)
                if mod(i,Qrows)==0
                    solrow=Qrows;
                else
                    solrow=mod(i,Qrows);
                end
                disp(['row ' num2str(i) ]);
                         
                low(solrow,1+fix((i-1)/Qrows),Sol_Nr)=sol_.low(Sol_Nr,i);
            end
            
            if any(fuzzy_maxmin(R,low(:,:,Sol_Nr))-T)
                disp('Error in solution')
            end
            
        end    
        sol=sol_;
        sol.low=low;
        sol.Xgr=Xgr;
    case 0
        disp(['no solution'])
        sol=sol_;
        Xgr=[]
        low=[]
        
end
save rela