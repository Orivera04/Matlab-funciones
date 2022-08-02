function [rules,newpos] = reorder(rules,index,dir)
%REORDER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:55:26 $

if ~ismember(dir,[-1 1])
    error('bad dir');
end
oldorder = 1:length(rules.fact_i1);
newpos = index + dir;
if  newpos<1 || newpos>length(rules.fact_i1)
    % Cannot promote the first or demote the last rule
    newpos = index;
    return
end

neworder = oldorder([1:index-1 index+1:end]);
neworder = [neworder(1:newpos-1) oldorder(index) neworder(newpos:end)];

rules.min1 = rules.min1(neworder);
rules.max1 = rules.max1(neworder);
rules.fact_i1 = rules.fact_i1(neworder);
rules.min2 = rules.min2(neworder);
rules.max2 = rules.max2(neworder);
rules.fact_i2 = rules.fact_i2(neworder);
rules.enable = rules.enable(neworder);
rules.exclude = rules.exclude(neworder);
