function [fstr,rulesstr,state,index] = info(rules,factors,index)
%INFO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:22 $

if nargin<3
    index = 1:length(rules.fact_i1);
end

fstr = []; rulesstr = []; state = []; index = [];
for i = 1:length(rules.fact_i1)
    if rules.fact_i1(i)==0
        namestr = 'Data point';
    else
        namestr = factors{rules.fact_i1(i)};
    end
    rulestr = [num2str(rules.min1(i)) ' < ' namestr ' < ' num2str(rules.max1(i))];
    if rules.fact_i2(i)==0
        newname = 'Data point';
    else
        newname = factors{rules.fact_i2(i)};
    end
    namestr = [namestr ', ' newname];
    rulestr = [rulestr ...
            '  &  ' num2str(rules.min2(i)) ' < ' newname ' < ' num2str(rules.max2(i))];
    fstr = [fstr {namestr}];
    rulesstr = [rulesstr {rulestr}];
    if ~rules.enable(i)
        thisstate = 0;
    elseif rules.exclude(i)
        thisstate = -1;
    else
        thisstate = 1;
    end
    state = [state thisstate];
    index = [index i];
end
