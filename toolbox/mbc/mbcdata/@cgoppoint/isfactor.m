function out = isfactor(p,factor)
% isfactor(p,ptrlist) returns 1 where ptr on ptrlist is a factor of p
% isfactor(p,names) returns 1 where names matches factor name

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:06 $

out = repmat(0,1,length(factor));
if length(p.ptrlist)>0
if isa(factor,'xregpointer')
    ptrlist = get(p,'ptrlist');
    out = [];
    for i = 1:length(factor)
        out = [out any(double(ptrlist)==double(factor(i)))];
    end
elseif ischar(factor) | iscell(factor)
    if ischar(factor)
        factor = {factor};
    end
    factors = get(p,'factors');
    out = [];
    for i = 1:length(factor)
        if ischar(factor{i})
            out = [out ~isempty(strmatch(factor{i},factors,'exact'))];
        else
            error('isfactor(p,names): names must be strings');
        end
    end
else
    error('isfactor(p,ptrlist/namelist)');
end
end
                