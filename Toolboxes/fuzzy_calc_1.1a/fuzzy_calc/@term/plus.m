function p = plus(v,w)
% function p = plus(v,w)
% sum two terms  v and w
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.


if (v(1).n~=0)&(w(1).n~=0)
v1=sterm(v);
v2=sterm(w);
p=v1+v2;
elseif (v(1).n==0)
    p=sterm(w);
elseif (w(1).n==0)
    p=sterm(v);
else
    disp('wrong input type for term/plus')
end
