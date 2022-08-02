function p = plus(v,w)
% function p = plus(v,w)
% sum of two sterms
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.


if isa(v,'sterm')&isa(w,'sterm')
    p=stermplus(v,w);
else
    if ~isa(v,'sterm')
        v=sterm(v);
    end
    if ~isa(w,'sterm')
        w=sterm(w);
    end
    if isa(v,'sterm')&isa(w,'sterm')
        p=stermplus(v,w);
        
    else
        error(' wrong type in sterm\plus ')
    end
end


function p=stermplus(v,w);
%vs=sterm(v);
vsL=length(v);
%ws=sterm(w); 
wsL=length(w);
p(1:vsL)=v;
p(vsL+1:vsL+wsL)=w;
p=sterm(p);



