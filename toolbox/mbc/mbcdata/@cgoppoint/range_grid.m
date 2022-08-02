function [p,i] = range_grid(p,ind,r_arg,c_arg);
% p = range_grid(p) build data grid using range settings in p.
% p = range_grid(p,ind) build data grid using factor(ind) ranges only.
%     Factors not used in the grid build are set to a constant.
% p = range_grid(p,[ind],ranges) build data grid over factors in ind
%     (all factors if ind not present), using cell array 'ranges'.
% p = range_grid(p,[ind],ranges,constants) use given constants for factors
%     not referenced by ind.
% [p,ind] = range_grid(...) returns the indices of factors actually used 
%     in the range grid. This may be different to a passed index list if 
%     some factors did not have a range set.
%
% See also: get(p,'grid_flag'), get(p,'range'), get(p,'constant')
%           eval_fill, cgoppoint

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:11 $

len = length(p.ptrlist);

grid_flag = p.grid_flag;
ranges = p.range;
constants = p.constant;
if nargin<2
    ro = grid_flag;
    ind = find(ro);
elseif iscell(ind)
    ranges = ind;
    ind = 1:length(p.ptrlist);
    if nargin==3
        constants = r_arg;
    end
elseif nargin==3
    ranges = r_arg;
elseif nargin==4
    ranges = r_arg;
    constants = c_arg;
end

if any(ind<0) | any(ind>len)
    error('Range_Grid: bad index into factors.');
elseif length(constants)~=len
    error('Range_Grid: number of constants must match number of factors.');
elseif length(ranges)~=length(ind)
    if length(ranges) == len
        %ind = 1:len;
    else
        error('Range_Grid: number of ranges must match number of indices.');
    end
elseif length(ranges) == length(ind)
    r = cell(1,len);
    for i = 1:length(ind)
        r{ind(i)} = ranges{i};
    end
    ranges = r;
end
% Added code to deal with no range case
% if isempty(ind)
% 	data = constants;
% 	p.data = data;
% 	return
% end

%don't range across blank columns
blank_ind = find(grid_flag==4 | grid_flag==8);
constants(blank_ind) = 0;
ind = setdiff(ind,blank_ind);

%don't range across constant columns
const_ind = find(grid_flag==0);
ind = setdiff(ind,const_ind);

ro = zeros(1,len);
c_empty = [];
indlen = length(ind);
for i = 1:indlen
    switch length(ranges{ind(i)})
    case 0
        constants(ind(i)) = 0;
    case 1
        constants(ind(i)) = ranges{ind(i)};
        c_empty = [c_empty ind(i)];
    otherwise
        ro(ind(i)) = 1;
    end
end
ind = find(ro);

in_i = find(p.factor_type==1);
ind = intersect(ind,in_i);  %can only grid across inputs

constind = setdiff(1:len,ind);

% Is there a block of imported data?
% Seperate out this block, and keep together.
block_ind = find(grid_flag==7 | grid_flag==9);
if length(block_ind)>0
    % work out length of block
    blocklen = ndblock(p,block_ind);
    block = p.data(1:blocklen,block_ind);
    % set ranges - these are checked for invertibility
    for i = 1:length(block_ind)
        ranges{block_ind(i)} = p.data(:,block_ind(i));
    end
else
    block = [];
end

groups = [];
for i = 1:max(p.group)
    groups = [groups {find(p.group==i)}];
end
ptrlist = p.ptrlist;
setval_ind = []; eval_ind = []; eval_ptr= []; old_val = [];
for i = 1:length(groups)
    found = intersect(groups{i},[ind block_ind]);   %always include block in gridding
    if any(ismember(found,block_ind))
        found2 = setdiff(found,block_ind);
        if ~isempty(found2)
            error('Range_Grid: gridding will overwrite imported data.');
        end
    end
    if (length(found)==0) & ~isempty(intersect(groups{i},c_empty))
        % Not setting any vector ranges - setting any constants?
        found = intersect(groups{i},c_empty);
    elseif length(found)==0
        %no setting going on in this group; check that everything agrees
        % fairly arbitrary - just pick first expression in group and force everything else to agree
        % Addition 3/x/01 - not so arbitrary. This section sets which factors in a group are to
        % be evalled and which have their values set. found must be set to the active group member.
        indep = find(p.grid_flag(groups{i}) ~= 8);
        if ~isempty(indep)
            found = groups{i}(indep(1));
        else
            error('CGOPPOINT/RANGE_GRID: A function exists with no independent variable');
        end
%         found = groups{i}(1);
        %set a range so that whole thing doesn't appear to have failed
        ranges{found(1)} = constants(found(1));
    end
    if length(found)>1
        error('Range_Grid: Cannot grid independently across two related variables.');
    else
        % Get the vector that is going to be changed.  There will be only one vector,
        %  since BuildRelatedGroups checks for this.
        % Store this in c_ptr; use this to set other values.
        dummy = 1;
        c_ptr = setvalue(ptrlist(found).info,dummy,ptrlist(found));
        %c_ptr = FindVector(ptrlist(found).info);
        if isempty(c_ptr)  %this was a value
            c_ptr = ptrlist(found); % give it the correct xregpointer 
        end
        % Go through list of constants
        % Any constant factors which are values must be set to their constant value,
        % so later setvalues and evaluations pick up these values.
        % Exclude the thing we're ranging over, and the ptr we're varying
        found_c = intersect(groups{i},setdiff(constind,found));
        for j = 1:length(found_c)
            ptr = ptrlist(found_c(j));
            if ptr.isddvariable & (ptr~=c_ptr)
                eval_ptr = [eval_ptr ptr];
                old_val = [old_val {ptr.info}];
                ptr.info = set(ptr.info,'value',constants(found_c(j)));   %set new values - may alter later setvalues
            end
        end
        
        % Flag the other dependants in the group as needing evaluation
        % % Try setting the values requested in range - find any that fail
        % %  and remove from range.
        % Flag this factor as needing setting.
        %[e,fail,new] = setvalue(ptrlist(found).info,ranges{found},c_ptr,[],[],'no_set');
        %get fail values - remove these from range setting
        %ranges{found} = setdiff(ranges{found},fail);    
        %if isempty(ranges{found})
            %all values have failed - no range left
            %set this factor to constant zero
        %    constind = union(constind,groups{i});    %set all this group to 0
        %    constants(groups{i}) = zeros(1,length(groups{i}));
        %else
            eval_ind = [eval_ind setdiff(groups{i},found)];    %evaluate the other dependants
            % mark this value as needing setting
            setval_ind = [found setval_ind];
            %put this to the start of eval_ptr (constants are already set, so setval_ind only includes this value)
            eval_ptr = [c_ptr eval_ptr];
            old_val = [{c_ptr.info} old_val];
            %end
    end
end

ind = setdiff(ind,block_ind);  %don't grid over block
constind = union(constind,block_ind);

ranges = {ranges{ind}};
constants = constants(constind);

if length(ranges)>1
    [ranges_ND{1:length(ranges)}] = ndgrid(ranges{:});
    for i = 1:length(ind);
        data(:,ind(i)) = ranges_ND{i}(:);
    end
elseif length(ranges)==1
    data(:,ind) = ranges{1}(:);
else 
    data = [];
end

datalen = size(data,1);
datalen = max(1,datalen);
if ~isempty(constind)
    data(:,constind) = repmat(constants,datalen,1);
end

if ~isempty(block_ind)
    p.data = data;
    p = ndblock(p,block_ind,block);   %keep import file block together
    data = p.data;
end

if ~isempty(setval_ind) & ~isempty(eval_ind)
    for i = 1:length(setval_ind)
        c_ptr = setvalue(ptrlist(setval_ind(i)).info,data(:,setval_ind(i)),ptrlist(setval_ind(i)));
        %[e,fail,new] = setvalue(ptrlist(setval_ind(i)).info,data(:,setval_ind(i)),eval_ptr(i),[],[],'no_set');
        %re-evaluate over ranged data
        %eval_ptr(i).info = set(eval_ptr(i).info,'value',new);  %may have been a value; need to explicitly set.
        if isempty(c_ptr) | c_ptr.isddvariable
            ptrlist(setval_ind(i)).info = set(ptrlist(setval_ind(i)).info,'value',data(:,setval_ind(i)));  %may have been a value; need to explicitly set.
        end
    end
    %evaluate dependants
    pCon = []; oldConVals = [];
    for i = 1:length(eval_ind)
        try
            % 1/x/01 - Addition for the evaluation of symvalues using i_eval
            if issymvalue(ptrlist(eval_ind(i)).info)
                allSymPtrs = getrhsptrs(ptrlist(eval_ind(i)).info);
                for k = 1:length(allSymPtrs)
                    if isconstant(allSymPtrs(k).info)
                        % 8/x/01 - Correction to get value of a constant !
                        ConVal = get(allSymPtrs(k).info, 'range');
                        ConVal = ConVal(1);
                        oldConVals{length(oldConVals) + 1} = ConVal;
                        pCon = [pCon allSymPtrs(k)];
                        symVal = repmat(ConVal, size(data, 1), 1);
                        allSymPtrs(k) = setvalue(allSymPtrs(k).info, symVal, allSymPtrs(k));
                    end
                end
            end
            newdata = ptrlist(eval_ind(i)).i_eval;
                
            if length(newdata)==1  %may be a constant
                newdata = repmat(newdata,datalen,1);
            end
            data(:,eval_ind(i)) = newdata;
        catch
            data(:,eval_ind(i)) = zeros(datalen,1); %may be a divide by zero
        end
    end
    %set constants back to original values
    for i = 1:length(pCon)
        pCon(i).info = set(pCon(i).info, 'value', oldConVals{i});
    end
end

%set values back to original values
for i = 1:length(eval_ptr)
    eval_ptr(i).info = old_val{i};
end

p.data = data;
