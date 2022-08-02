function [n,d]=term2num(t)
% function [n,d]=term2num(t)
% converts term to numerical array 
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

if isa(t,'term')
    for i=1:length(t)
        n(i)=t(i).n;
        d(i)=t(i).d;
    end
else
    error('wrong input type')
end