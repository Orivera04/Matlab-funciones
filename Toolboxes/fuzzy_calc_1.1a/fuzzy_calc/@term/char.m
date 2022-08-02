function s = char(p)
%function s = char(p)
% TERM/CHAR   
% CHAR(p) is the string representation of the term p
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.
s=[];
% disp('in char')
% keyboard
if (length(p)>0)&(~isempty(p))
    for k=1:length(p)
        if isempty(s)
            s=[];
        else
            s=[s '.'];
        end
        s = [s '<' num2str(p(k).n) '/' num2str(p(k).d) '>']; 
    end
else
    s=' empty term '
end
