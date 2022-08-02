function op = CheckDataset(op,pr)
% CGOPPOINT/CHECKDATASET
% op = CheckDataset(op)
%  Checks: units, groups, ddvariables

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.5 $  $Date: 2004/04/04 03:25:55 $

if ~isempty(op.ptrlist) && any(isvalid(op.ptrlist))
    op = CheckGroup(op,false);
    op = i_CheckConstants(op);
    % Units not used so don't check
    % op = i_CheckUnits(op);
    if nargin>2
        op = CheckNames(op,pr);
    end
    op = i_CheckSpecials(op);
    
    % now do eval fill
    op= eval_fill(op);
end


%---------------------------------------
            

%---------------------------------------
function op = i_CheckConstants(op)
%---------------------------------------
%  Check assigned ptrs for if ddvariable; disallow constants (unassign)
valid_idx = find(isvalid(op.ptrlist));
hObj = infoarray(op.ptrlist(valid_idx));

for n = 1:length(valid_idx)    
    ptr = op.ptrlist(valid_idx(n));
    if isddvariable(hObj{n}) && isconstant(hObj{n})
        % Anything linked to this factor?
        % Create internal ptr to maintain link.
        f2 = (op.linkptrlist==ptr);
        if any(f2)
            op = AddCage(op,valid_idx(n));
            op.linkptrlist(f2) = op.ptrlist(valid_idx(n));
        end
        % unassign
        op.ptrlist(valid_idx(n)) = 0;
        if isempty(op.orig_name{valid_idx(n)})
            op.orig_name{valid_idx(n)} = getname(hObj{n});
        end
    end
end

        

%---------------------------------------
function op = i_CheckUnits(op)
%---------------------------------------
%  Check the unit type of all assigned factors against
%  the expression unit type.  Convert data to match expression unit.
%  Incompatible units are replaced, but data is left unchanged.

% replace some duff units in an earlier version
% These lines can probably be removed at some point.
if ~iscell(op.units)
    op.units = cell(1, length(op.ptrlist));
    for n = 1:length(op.units)
        op.units{n} = junit;
    end
end

valid_i = find(isvalid(op.ptrlist));
for i = 1:length(valid_i)
    fact_i = valid_i(i);
    eunit = op.ptrlist(fact_i).grabUnits;
    opunit = op.units{fact_i};
    if ~isempty(eunit) && ~isempty(opunit)
        if compatible(eunit,opunit)
            op.data(:,fact_i) = convert(opunit,eunit,op.data(:,fact_i));
        else
            % leave data unchanged if not compatible
        end
    end
    % ensure dataset units match expression units
    op.units{fact_i} = eunit;
end


%---------------------------------------
function op = i_CheckSpecials(op)
%---------------------------------------
% Check anything created from feature.  
% Ensure current model and equation both present.

FeatIdx = find(op.created_flag==-2);
if isempty(FeatIdx)
    return
end

AllFeatPtr = op.ptrlist(FeatIdx);
AllFeatLinkPtr = op.linkptrlist(FeatIdx);
FeatLinkObj = infoarray(AllFeatLinkPtr);

FeatPtr = unique(AllFeatPtr);
FeatObj = infoarray(FeatPtr);

% Mapping pointers used to do quick updates when model/equation has changed
FeatRemap = null(xregpointer, [0 2]);

% Columns that are no longer needed and Features that need to be re-added:
% this is done in one shot at the end
ColsToRemove = [];
FeatsToAdd = null(xregpointer, 0);


% For each feature, check that it's model and strategy pointers are up to
% date.  If not, change them and record in FeatRemap so that any errors can
% also be updated afterwards.
for n = 1:length(FeatObj)
    % Get info on the features current setup
    NewMdlPtr = get(FeatObj{n}, 'model');
    HasNewMdl = ~isempty(NewMdlPtr);
    NewEqPtr = get(FeatObj{n}, 'equation');
    HasNewEq = ~isempty(NewEqPtr);
    
    % Get info on how the feature looked last time the oppoint was updated
    itemsidx = find(AllFeatPtr==FeatPtr(n));
    if length(itemsidx)>2
        % This is an unexpected state.  Schedule this feature for complete
        % removal and re-adding
        ColsToRemove = [ColsToRemove, FeatIdx(itemsidx)];
        FeatsToAdd = [FeatsToAdd, FeatPtr(n)];
        
    elseif length(itemsidx)==2
        % model and equation currently in oppoint, work out which is which
        if isa(FeatLinkObj{itemsidx(1)}, 'cgmodexpr')
            OldMdlIdx = itemsidx(1);
            OldEqIdx = itemsidx(2);
        else
            OldMdlIdx = itemsidx(2);
            OldEqIdx = itemsidx(1);
        end
        
        if HasNewMdl && HasNewEq
            % Place new model and equation into the list of required maps
            if NewEqPtr~=AllFeatLinkPtr(OldEqIdx)
                FeatRemap = [FeatRemap; AllFeatLinkPtr(OldEqIdx), NewEqPtr];
                AllFeatLinkPtr(OldEqIdx) = NewEqPtr;
            end
            
            if NewMdlPtr~=AllFeatLinkPtr(OldMdlIdx)
                % Also need to check that whether the old model was in the
                % dataset in its own right - don't need to remap if this is
                % the case
                OldMdlPtr = AllFeatLinkPtr(OldMdlIdx);
                AllFeatLinkPtr(OldMdlIdx) = NewMdlPtr;
                if ~any(op.ptrlist==OldMdlPtr)
                    FeatRemap = [FeatRemap; OldMdlPtr, NewMdlPtr];
                end
            end
            
        else
            if ~HasNewMdl
                % Schedule column removal
                ColsToRemove = [ColsToRemove, OldMdlIdx];
            end
            if ~HasNewEq
                % Schedule column removal
                ColsToRemove = [ColsToRemove, OldEqIdx];
            end
        end
        
    else
        % Only one item currently in oppoint
        HasOldMdl = false;
        HasOldEq = false;
        if isa(FeatLinkObj{itemsidx}, 'cgmodexpr')
            HasOldMdl = true;
        else
            HasOldEq = true;
        end

        if HasNewMdl && HasNewEq
            % The new feature item needs to be added properly
            ColsToRemove = [ColsToRemove, itemsidx];
            FeatsToAdd = [FeatsToAdd, FeatPtr(n)];   
        elseif HasNewMdl && HasOldMdl
            if ~any(op.ptrlist==AllFeatLinkPtr(itemsidx))
                FeatRemap = [FeatRemap; AllFeatLinkPtr(itemsidx), NewMdlPtr];
            end
            AllFeatLinkPtr(itemsidx) = NewMdlPtr;
        elseif HasNewEq && HasOldEq
            FeatRemap = [FeatRemap; AllFeatLinkPtr(itemsidx), NewEqPtr];
            AllFeatLinkPtr(itemsidx) = NewEqPtr;
        else
            % The new and old column types don't match
            ColsToRemove = [ColsToRemove,itemsidx];
            FeatsToAdd = [FeatsToAdd, FeatPtr(n)];
        end
    end
end

% Put changes back into main ptrlist
op.linkptrlist(FeatIdx) = AllFeatLinkPtr;

% Find all outputs that are dataset-held and check each one for being an
% error that needs it's inputs checking against the map we have created
if ~isempty(FeatRemap)
    possible_sums = (op.factor_type==2) & (op.created_flag==1);
    if any(possible_sums)
        for n = find(possible_sums)
            hSum = op.ptrlist(n).info;
            if isa(hSum, 'cgsubexpr')
                ANY_REMAPPED = false;
                
                pLeft = get(hSum, 'left');
                remapidx = find(FeatRemap(:,1)==pLeft);
                if ~isempty(remapidx)
                    hSum = set(hSum, 'left', FeatRemap(remapidx,2));
                    ANY_REMAPPED = true;
                end
                    
                pRight = get(hSum, 'right');
                remapidx = find(FeatRemap(:,1)==pRight);
                if ~isempty(remapidx)
                    hSum = set(hSum, 'right', FeatRemap(remapidx,2));
                    ANY_REMAPPED = true;
                end
                
                if ANY_REMAPPED
                    % Update heap copy
                    op.ptrlist(n).info = hSum;
                end
            end
        end
    end
end

% Remove columns and add features
if ~isempty(ColsToRemove)
    op = removefactor(op,FeatIdx(ColsToRemove),false);
end
if ~isempty(FeatsToAdd)
    op = AddExpr(op, FeatsToAdd,false);
end

