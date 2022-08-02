function [index,notindex] = Apply(rules,data)
% index = Apply(rules) applies all filter rules, returning indices of selected points.
% [index,notindex] = Apply(rules) returns non-selected points.
% [index,notindex] = Apply(op,factor) returns selected points,
%           non-selected points, and points not selected due to rules on given factor.
% [...] = ApplyRules(op,0) uses data point as current rule.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:17 $


other = [];
index = []; first = 1;
if ~isempty(rules.fact_i1)
    for i = 1:length(rules.fact_i1)
        
        % find all enabled rules for this input
        if rules.enable(i)
            
            if rules.fact_i1(i)==0
                this = 1:size(data,1);
            else
                this = data(:,rules.fact_i1(i));
            end
            thisind = find(this>=rules.min1(i) & this<=rules.max1(i));
            % Perform AND with other region rule
            if rules.fact_i2(i)==0
                this = 1:size(data,1);
            else
                this = data(:,rules.fact_i2(i));
            end
            thisind = intersect(thisind,find(this>=rules.min2(i) & this<=rules.max2(i)));
            if rules.exclude(i)
                if first
                    index = 1:size(data,1);
                end
                index = setdiff(index,thisind);
            else
                % perform OR on other rules 
                index = union(index,thisind);
            end
            first = 0;
        end
    end
else
    index = 1:size(data,1);
end

index = index(:)';
notindex = setdiff(1:size(data,1),index);
