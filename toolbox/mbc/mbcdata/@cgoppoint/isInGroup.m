function [gpno,gpmembers] = isInGroup(op,thing,opt);
% [gpno,gpmembers] = isInGroup(op)
% [gpno,gpmembers] = isInGroup(op,ind)
%   returns group number for each factor, and cell array of group members.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:59 $

if nargin<2
    thing = 1:length(op.ptrlist);
elseif ~isnumeric(thing)
    error('cgoppoint::isInGroup: require factor index.');
elseif any(~ismember(thing,1:length(op.ptrlist)))
    error('cgoppoint::isInGroup: bad index into factors');
end

if length(op.ptrlist)==0
    in = repmat(0,1,length(thing));
    gpmembers = [];
    return
end

gpno = op.group(thing);
if nargout>1
    gpmembers = [];
    for i = 1:max(op.group)
        gpmembers = [gpmembers {find(op.group==i)}];
    end
end

