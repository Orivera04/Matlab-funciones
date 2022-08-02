function groups = BuildRelatedGroups(p,ind);
% groups = BuildRelatedGroups(p) returns a cell array of groups.
%      Each cell contains a vector of indices to the factors
%      of p belonging to a group.
%      A group consists of any inputs which depend on the same
%      variable, in one dimension only.
% group = BuildRelatedGroups(p,ind), where ind is scalar, returns
%      empty if the factor does not belong to a group, or the 
%      vector of factors which belong to the group.
%       If ind is vector, group is a cell array, containing empty
%      or the group for each indexed factor.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:25:54 $

%build groups
groups = {};
for i = 1:max(p.group)
    groups{i} = find(p.group==i);
end
return


if nargin<2
    ind = 1:length(p.factorinfo);
elseif ~isnumeric(ind) | ~all(ismember(ind,1:length(p.factorinfo)))
    error('BuildRelatedGroups: bad index into factors.');
end
if nargin==2 & length(ind)==1
    outcell = 0;
else
    outcell = 1;
end

if isempty(p)
    groups = {};
else
ptrlist = [p.factorinfo.ptr];
factortype = {p.factorinfo.factortype};
ind = intersect(ind,strmatch('input',factortype));  %only inputs

for j = 1:length(ind)
    i = ind(j);
    this_p = ptrlist(i);
    if isvalid(this_p) & ~this_p.isa('cgvariable')
        dep_p = this_p.getAllInputs;
        vec_p = this_p.vectors;
        group = [];
        for j = 1:length(dep_p)
            f = find(dep_p(j)==ptrlist);     %check for match
            f = f(strmatch('input',factortype(f),'exact'));  %only include inputs
            if ~isempty(f) & length(vec_p)<2  %exclude 2-D dependencies
                group = [group f i];
            end
        end
        if ~isempty(group)
            found = 0;
            for k = 1:length(groups)
                if ~isempty(intersect(groups{k},group))
                    groups{k} = union(groups{k},group);
                    found = 1;
                end
            end
            if ~found
                groups = [groups {unique(group)}];
            end
        end
    end
end
if ~outcell & length(groups)==1
    groups = groups{1};
end

end