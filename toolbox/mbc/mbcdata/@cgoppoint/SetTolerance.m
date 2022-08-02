function [p,tol] = SetTolerance(p,varargin)
% p = SetTolerance(p)
%    Calculate the optimal tolerance for each factor in p.
%    Tolerance is used in table filling and data display.  It defines which points
%      will be used in a second or third dimension, and is used to compare points
%      against either an internal range or a parameter value.
%    The tolerance is optimised to avoid two situations:
%      1: too high a tolerance will cause data to be repeated, or selected 
%         against multiple parameter values
%      2: too low a tolerance may cause some data to be missed.
% p = SetTolerance(p,ind)
%    Set tolerance for factors indexed by ind.
% p = SetTolerance(p,[ind],opt)
%    opt = 'all', 'no_repeats', 'optim', 'quick'.
%       'all' adjusts tolerance to include all data (but some points may be repeated).
%       'no_repeats' ensures no point is covered twice (but some may be missed).
%       'optim' (default) optimises tolerance to minimise number of repeats and number of misses.
%       'quick' includes most data (less rigorous than 'all', but about 6 times faster).
% p = SetTolerance(p,[ind],opt,use)
%    use = 'internal', 'param', 'both'.
%       'internal' adjusts tolerance by comparing points against internal range only.
%       'param' compares against the parameter value, if the factor is linked to a value.
%       'both' (default) averages tolerance due to the two methods.
% p = SetTolerance(p,[ind],opt,use,wt)
%    Set weight used in optimiser.  Wt defines number of misses to number of repeats,
%       so increasing wt will tend to lower the number of repeats.
% [p,tol] = SetTolerance(...)
%    Return vector of tolerances.
%
% See also: SetRange

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:22 $

if nargin>1 & isnumeric(varargin{1})
    ind = varargin{1};
    argsused = 2;
else
    ind = 1:get(p,'numfactors');
    argsused = 1;
end
if nargin<argsused+1
    opt = 'optim';
else
    opt = lower(varargin{argsused}); 
end
if nargin<(argsused+2)
    use = 'internal'; %set tolerance to agree with dataset
else
    use = lower(varargin{argsused+1}); 
end
if nargin<(argsused+3)
    wt = 2;
else
    wt = varargin{argsused+2};
end

if ~all(ismember(ind,1:get(p,'numfactors')))
    error('SetTolerance: bad index into factors');
    return
end

if ~isempty(p)
    %do some setting up
    tol = get(p,'tolerance');
    for factornum = ind;
        tol(factornum) = i_CalcTolerance(opt,use,p,factornum,wt);
    end
    p = set(p,'tolerance',tol);
end
        
%------------------------------------------------------------------------
function [tabdata,rownumindices,val,range] = i_MassageData(p,factornum)
%------------------------------------------------------------------------
if isempty(p.data)
    tabdata = [];
    rownumindices = [];
else
    tabdata = p.data(:,factornum);
    d1 = unique(tabdata);
    rownumindices = [];
    for j = 1:length(d1)
        if isempty(tabdata)
            f = [];
        else
            f = find(d1(j)==tabdata);
        end
        rownumindices(j) = length(f);
    end
    tabdata = d1;
end
ptr = p.ptrlist(factornum);
range = p.range{factornum};
if ~isvalid(ptr) | ~isa(ptr.info,'cgvariable')
    val = [];
else
    val = ptr.get('value'); val = val(:)';
end

%------------------------------------------------------------------------
function tol = i_CalcTolerance(opt,tol_use_value,p,factornum,optimweight)
%------------------------------------------------------------------------
if strcmp(tol_use_value,'both')
    tol_use_value = {'internal','param'};
elseif ischar(tol_use_value)
    tol_use_value = {tol_use_value};
end
% get some data
[tabdata,rownumindices,val,range] = i_MassageData(p,factornum);
tol_many = [];

for goes = 1:length(tol_use_value)

switch tol_use_value{goes}
case 'param'
    value = val(:);
case 'internal'
    value = range(:);
otherwise
    error('SetTolerance: unrecognised use option.  use = param | internal | both.');
end

if isempty(value)
    tol = 0;
else
    if isempty(tabdata) %no data in the table, so optimise against the parameter/range.
        tabdata = value;  %Tolerance may well vary with different data, depending on
                          %the distribution of the data and range points, especially
                          %if the range/value is not regularly spaced.
        rownumindices = ones(1,length(tabdata));
    end
    % A bit of matrix manipulation..
    A = repmat(tabdata(:)',length(value),1);
    B = repmat(value(:),1,length(tabdata));
    C = abs(A-B);   %difference between each data value in the table and each parameter value
    [mins,i] = min(C,[],1);  %vector of min tolerances to include each data value
    tol_all = max(mins);    %this is the tolerance if all data must be included
    
    if strcmp(opt,'quick')
        tol = tol_all+0.1;
    else
    min_ind = i + [0:length(i)-1].*size(C,1);
    C(min_ind) = Inf;   % get rid of those minimum differences we found
    minsrep = min(C,[],1);   % ...and find the next lowest difference
    % this vector is the max tolerance for each data value for no doubles
    tol_repeat = min(minsrep);  %this is the max tolerance if we are to have no doubles
    D = repmat(mins,length(mins),1);
    E = repmat(minsrep',1,length(mins));
    F = D-E;
    F = diag(rownumindices)*(F>0);   %multiply in the number of indices on each row (if unique data)
    reps = sum(F);   %number of doubles for each min tolerance
    G = diag(rownumindices)*((D-D')<0);
    misses = sum(G); %number of misses for each min tolerance
    wt = misses+reps*optimweight; %both misses and doubles are bad - use optimweight to adjust the weighting between them
    [minwt,i] = min(wt);    % find the 'best' tolerance
    tol_optim = mins(i);
    
    switch opt
    case {'optim','optimise'}
        next = min(minsrep(find(minsrep>mins(i)))); %find the tol which would cause increased no. of repeats
        if isempty(next), next = mins(i)+1; 
        elseif isinf(next), next = tol_optim.*2; end
        tol = (tol_optim + next)./2;  %go between them
    case 'all'
        next = min(minsrep(find(minsrep>tol_all)));     %set tol to a bit above desired value to compensate for machine precision
        if isempty(next), next = tol_all+1; 
        elseif isinf(next), next = tol_all.*2; end % ...calculate range where increasing tol has no effect, and set to middle of this
        tol = (tol_all + next)./2;  
    case {'no_repeats','norepeats','norepeat'}
        next = max(mins(find(mins<tol_repeat))); 
        if isempty(next), next = tol_repeat-1; end
        if isinf(tol_repeat), tol_repeat = next.*2; end
        tol = (tol_repeat + next)./2;  
    otherwise
        error('SetTolerance: unrecognised option.  opt = optim | all | no_repeats.');
    end
    end
end
tol_many = [tol_many tol];
end
if sum(tol_many~=0)==0  %probably a constant
    tol = 1;
elseif length(tol_use_value)==2 %doing both - do all and no_repeats over all data
    tol_many = tol_many(find(tol_many));
    switch opt
    case 'all'
        tol = max(tol_many);
    case {'no_repeats','norepeats','norepeat'}
        tol = min(tol_many);
    otherwise
        tol = sum(tol_many)./sum(tol_many~=0);
    end
else
    tol = sum(tol_many)./sum(tol_many~=0);
end