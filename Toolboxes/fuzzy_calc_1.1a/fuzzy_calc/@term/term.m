function p = term(a)
% Fuzzy term class constructor.
%   p = term(a,d) creates a fuzzy object from the vector numerator "a"
%   and denumerator "d".
% y(i) = varargin{i}(2);
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

if isa(a,'sterm')
    if length(a)==1
        p=a(1).t;
    else
        error('inpossible conversion from summe of terms to term')
    end
    
elseif isa(a,'term')
    p = a;
    
elseif isstruct(a)
    if (isfield(a,'n'))&(isfield(a,'d'))
        k1=0;
        for k=1:length(a)
            if (a(k).n~=0)&(a(k).d~=0)&(~isempty(a(k).n))&(~isempty(a(k).d))
                k1=k1+1;
                p(k1).n = a(k).n;
                p(k1).d = a(k).d;
            end
        end
        if k1>0
            p = class(p,'term');
        else
            p(1).n = 0;
            p(1).d = 1;
            p = class(p,'term');
        end    
    else
        error('not a proper structure');
        return;
    end
    
elseif isnumeric(a)
    if (min(size(a))==1)&(max(size(a))>=1)
        k1=0;
        for k=1:length(a)
            if a(k)~=0
                k1=k1+1;
                p(k1).n = a(k);
                p(k1).d = k;
            end
        end
        if k1>0
            p = class(p,'term');
        else
            p(1).n = 0;
            p(1).d = 1;
            p = class(p,'term');
        end
    else
        
        error('term:baddim','Wrong Input  !')
        
    end
end

p=sort(p);