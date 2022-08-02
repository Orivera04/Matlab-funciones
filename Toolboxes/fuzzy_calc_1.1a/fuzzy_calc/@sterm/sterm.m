function p = sterm(v)
% function p = sterm(v)
% Fuzzy summe of terms  class constructor.
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

% y(i) = varargin{i}(2);


if isa(v,'term')
    p(1).t=v;
    p=class(p,'sterm');
    
elseif isa(v,'sterm')
    p=v;
    
elseif isa(v,'numeric')
    
    if (min(size(v))==1)&(max(size(v))>=1)
        k1=0;
        for k=1:length(v)
            if v(k)~=0
                k1=k1+1;
                st(k1).n = v(k);
                st(k1).d = k;
                st = term(st);
                sp(k1).t=st;
                clear st;
            end
        end
        
        if k1<=0
            spt(1).n = 0;
            spt(1).d = 1;
            spt = term(spt);
            sp(1).t=spt;
        end
        p=class(sp,'sterm');
    else
        error('wrong input type')
        
    end
end
p=absorbadd(p);

%