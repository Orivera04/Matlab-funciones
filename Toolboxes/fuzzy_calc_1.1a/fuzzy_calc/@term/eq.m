function r = eq(p,q)
% function r = eq(p,q)
% "equals to" for two terms
% returns 1, if p==q, 0 otherwise
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

if isa(p,'term')&(isa(q,'term'))
    if (p(:).n==q(:).n)&(p(:).d==q(:).d)
        r=1;
    else
        r=0;
    end
else
    r=0;
end