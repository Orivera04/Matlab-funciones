function p = sterm2terms(v)
% function p = sterm2terms(v)
% convert sterm to terms
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

if isa(v,'sterm')
    for i=1:length(v)
        p{i}=term(v(i).t);
    end
else
    error('is not a sterm');
end
