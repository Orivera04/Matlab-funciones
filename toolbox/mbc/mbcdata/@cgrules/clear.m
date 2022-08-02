function rules = clear(rules,index)
% rules = clear(rules,index)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:20 $

if ~ismember(index,1:length(rules.fact_i1))
    error('bad index');
end

rules.min1(index) = [];
rules.max1(index) = [];
rules.fact_i1(index) = [];
rules.min2(index) = [];
rules.max2(index) = [];
rules.fact_i2(index) = [];
rules.enable(index) = [];
rules.exclude(index) = [];

