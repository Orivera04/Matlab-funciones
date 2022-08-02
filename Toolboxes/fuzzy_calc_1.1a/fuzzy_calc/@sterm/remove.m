function s=remove(s,numb)
% function s=remove(s,numb)
% removes the number numb element from the sterms s
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

if isa(s,'sterm')
    for i=1:numb-1
        s1(i)=s(i);
    end
    for i=numb:length(s)-1
        s1(i)=s(i+1);
    end
    s=s1;
else
    error('wrong inptu  sterm/remove')
end
    
