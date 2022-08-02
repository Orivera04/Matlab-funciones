function rules = update(rules,index,xlim,ylim)
% rules = update(rules,index,xlim,ylim)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:55:28 $

if ~isempty(xlim)
    rules.min1(index) = xlim(1);
    rules.max1(index) = xlim(2);
end
if ~isempty(ylim)
    rules.min2(index) = ylim(1);
    rules.max2(index) = ylim(2);
end
