function tssf = applyDefaultSelection(tssf)
%TSSF = APPLYDEFAULTSELECTIONTSSF) selects and unselects data from the
%current clusters with reference to current defaultSelection settings
%
%  TSSF = APPLYDEFAULTSELECTIONTSSF(TSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $Date: 

%% tssf.derfaultSelection.apply is a logical flag that can be used
%% ELSEWHERE to determine whether or not to call this method.
%% Currently this method does NOT itself look at this flag, it just runs
%% the defaults regardless.

%% user choices are found in tssf.defaultSelection.XXXX
% unmatcheddata  all/none
% moreData   all/closest
% moreDesign closest/none

%% clusters is a struct array
[c, design, data, tol] = get(tssf, {'clusters', 'actualDesign', 'meanData', 'tolerances'});


%% dataonly cluster
ind = find(strcmp({c.status}, 'unmatcheddata'));
USEALL = strcmp(tssf.defaultSelection.unmatcheddata, 'all');
for i=1:length(ind) %% can only be one?
    if USEALL %%keep
        tssf = setClusterSelectedData(tssf, c(ind).data, ind(i));
    else
        tssf = setClusterSelectedData(tssf, [], ind(i));
    end
end

%% clusters with more design than data
ind = find(strcmp({c.status}, 'moredesign'));
NONE = strcmp(tssf.defaultSelection.moredesign, 'none');
for i = ind
    if  NONE%%use all data, leave unmatched
        tssf = setClusterSelectedData(tssf, c(i).data, i);
        tssf = setClusterSelectedDesign(tssf, [], i);
        
    else %% match each des point to closest data
        thisData = data(c(i).data,:);
        tssf = setClusterSelectedData(tssf, c(i).data, i);

        nearestDesInds = i_findNearest(thisData, design(c(i).design, :), tol);
        
        tssf = setClusterSelectedDesign(tssf, c(i).design(nearestDesInds), i);
    end
end


%% clusters with more data than design
ind = find(strcmp({c.status}, 'moredata'));
USEALL = strcmp(tssf.defaultSelection.moredata, 'all');
for i = ind
    if USEALL %%use all data
        tssf = setClusterSelectedData(tssf, c(i).data, i);
        tssf = setClusterSelectedDesign(tssf, c(i).design, i);
        
    else %% match each des point to closest data
        thisDesign = design(c(i).design,:);
        tssf = setClusterSelectedDesign(tssf, c(i).design, i);

        nearestDataInds = i_findNearest(thisDesign, data(c(i).data, :), tol);
        
        tssf = setClusterSelectedData(tssf, c(i).data(nearestDataInds), i);
    end
end


% ------------------------------------------------------------
% function i_findNearest(fH)
% ------------------------------------------------------------
function out = i_findNearest(points, universe, tol)
% Ensure that value is the same size as data

npoints = size(points,1);
nuniverse = size(universe, 1);
out = zeros(npoints,1);
tol = repmat(tol(:)', nuniverse, 1);

for i= 1:npoints
    value = repmat(points(i,:), nuniverse, 1);
    % Form a distance metric
    distance = (value - universe)./ tol;
    
    [lb, out(i)] = min(sum(distance.*distance,2));
    
    universe(out(i),:) = Inf;

end