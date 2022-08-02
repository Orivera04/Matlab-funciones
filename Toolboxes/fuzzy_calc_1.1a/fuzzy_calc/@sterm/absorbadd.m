function p=absorbadd(p);
% function p=absorbadd(p);
% absorption from addition
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

if length(p)>=2
    i=1;
    while (i<=length(p))
        j=i+1;
        while (j<=length(p))
            %disp('---------')
         %   p(i).t
          %  p(i+1).t
%            lesthan=(p(i).t<=p(i+1).t);
             lesthan=(p(i).t<=p(j).t);
            switch lesthan
                case 1
                    p=remove(p,j);
                    p=absorbadd(p);
                    return
                case 0
                    p=remove(p,i);
                    p=absorbadd(p);
                    return
                otherwise
                    p=p;
                    %                   removed=0;
                    
            end
            j=j+1;
        end
        i=i+1;
    end
end

