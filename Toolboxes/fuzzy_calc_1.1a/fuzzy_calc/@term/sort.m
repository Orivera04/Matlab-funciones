function t=sort(t)
% function t=sort(t)
% arranges the elements in the term ascendingly with respect to denomitaors
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

if isa(t,'term')
    if length(t)>1
        
        % cheking if is sorted
        i=2;sorted=1;
        while (i<=length(t))&sorted
            if t(i-1).d > t(i).d
                sorted=0;
                i=i+1;
            elseif t(i-1).d<t(i).d
                sorted=1;
                i=i+1;
            else 
                error('wrong term, equal denumerators')
            end
        end
        
        % 
        if sorted
            t=t;
        else
            % sort the terms of the term
            % --------------------------
            while ~sorted
                sorted=1;
                for i=2:length(t)
                    if t(i-1).d>t(i).d
                        tempt=t(i-1);
                        t(i-1)=t(i);
                        t(i)=tempt;
                        sorted=0;
                    end
                end
                
            end
            
            % --------------------------
            % end of sorting the terms of the term
            
        end  
        
    else
        t=t;
    end
 
    
else
    error(' wrong input argument, not a term, could not be sorted')
    t=[];
end
