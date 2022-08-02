function r = mtimes(p,q)
% TERM/MTIMES  Implement p * q for terms.
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

%k = length(q.n) - length(p.n);

if (isa(p,'term')&(isa(q,'term')))
    r=multterms(p,q);   
elseif (isa(p,'sterm')|(isa(q,'sterm')))
    
    if ~isa(p,'sterm')
        p = sterm(p); 
    end
    if ~isa(q,'sterm')
        q = sterm(q);
    end
    if (isa(p,'sterm')&(isa(q,'sterm')))
        r=p*q;   
    else
        r=[];
        error(' error in conversion')
    end
else
    if ~isa(p,'term')
        p = term(p); 
    end
    if ~isa(q,'term')
        q = term(q);
    end
    if (isa(p,'term')&(isa(q,'term')))
        r=multterms(p,q);   
    else
        r=[];
        error(' error in conversion ')
    end
end

function r=multterms(p,q)
for ip=1:length(p)
    r=q;
    isdone=0; % 1 if the p(ip) element is already multipliciert
    for iq=1:length(q)
        if p(ip).d==q(iq).d
            r(iq).n=max(p(ip).n,q(iq).n);
            isdone=1;
        end
    end
    if ~isdone
        r(iq+1).n=p(ip).n;
        r(iq+1).d=p(ip).d;
    end
    q=r;
end

r=term(r);
