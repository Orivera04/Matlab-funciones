function rules = add(rules,min,max,fact_i)
% rules = add(rules,min,max,factor)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:18 $

if length(min)~=length(max) | length(min)~=length(fact_i)
    error('min, max, factor must be same length');
end
if length(min)~=2
    error('min must be length 2');
end

rules.min1 = [rules.min1 min(1)];
rules.max1 = [rules.max1 max(1)];
rules.fact_i1 = [rules.fact_i1 fact_i(1)];
rules.min2 = [rules.min2 min(2)];
rules.max2 = [rules.max2 max(2)];
rules.fact_i2 = [rules.fact_i2 fact_i(2)];
rules.enable = [rules.enable 1];
rules.exclude = [rules.exclude 0];
    
