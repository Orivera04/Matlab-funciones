function m = mtimes(v,w)
% function m = mtimes(v,w)
% multiplys two sterms 
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.


if isa(v,'sterm')     
    vt=sterm2terms(v);
elseif isa(v,'term')     
    vt=v;
else     
    vt=term(v);
end
vL=length(vt);

if isa(w,'sterm')
    wt=sterm2terms(w);
elseif isa(w,'term')
    wt=w;
else
    wt=temr(w);
end
wL=length(wt);

k=0;
m=term([0]);
for i=1:vL
    for j=1:wL
        k=k+1;
%         vt{i}
%         wt{j}
%         vt{i}*wt{j}
        m=m+(vt{i}*wt{j});
    end
end
