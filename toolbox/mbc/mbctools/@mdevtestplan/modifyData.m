function T = modifyData(T, pTSSF, newData, changes)
%MDEVTESTPLAN/MODIFYDATA 
%
%  [T] = modifyData(T, pTSSF, NewData);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:31:35 $

if nargin < 4
    % If we haven't been supplied with a set of changes that the data will
    % have then we need to calculate them for ourselves.
    changes = pAssessDataChanges(T, newData);
end
% Most major check is that we haven't got here with an impending
% INPUT_SIGNAL_REMOVED in the changes. That would be really bad for the
% testplan. Lets think about throwing an error as we really can't claim to
% have modified the data and we can't restore an existing testplan.
if changes.INPUT_SIGNAL_REMOVED
    error('mbc:mdevtestplan:InvalidState', 'Input factors for this test plan are not present in data set');
end
% Check the responses in relation to the changes made
T = i_modifyResponses(T, changes);
% Check the Monitor variables
T = i_modifyMonitorVariables(T, changes);
% Do some legacy setup of the response surface and cross-section memory
T = i_legacyPlotMemorySetup(T);
% Get the new actualDesign
actualDesign = get(newData, 'codeddesign');
% OK - most modifications that need to be made to the testplan have been
% carried out. It's time to actually start changing real data
% Prepare the data for being put into the testplan
% Clear all the caches.
newData = clearCachedInfo(newData);

% Get the old and new data for outlier updateing after data changes. Not
% sure but it's possible that OldData is probably using a pointer that
% could be modified by the modfiyData call below, so get the interesting
% stuff before we actually do that.
if numChildren(T) > 0
    oldSS = sweepset(changes.OldData);
    newSS = sweepset(newData);
end

% Modify project data - This writes newData correctly back into the project
modifyData(info(project(T)), pTSSF, newData);

if changes.ACTUAL_DESIGN_CHANGED
    T.DesignDev = setActualDesign(T.DesignDev, actualDesign);
end
% assign new data to test plan	
T = i_assignMatch(T, pTSSF, newData);
% Any changes in data that is being
if changes.DATA_CHANGED   
    % Which responses need refitting
    if changes.RESPONSE_DATA_CHANGED
        if numChildren(T) > 0
            % Update outlier indices for new data
            T = updateOutlierIndices(T, newSS, oldSS);
            % Get the names of the responses 
            responseNames = children(T, 'varname');
            % Which ones actually are still here - Make sure we only modify those that are Changed
            [found, location] = ismember(changes.ResponseSignalsChanged, responseNames);
            % Need to update any datum linked responses as well as those
            % that have changed - NOTE that datum is the first response and
            % so only need to find links if the first response is changed
            % and 
            linkedIndex = [];
            if any(location == 1)
                % Which other responses need to be removed
                linkedIndex = getDatumLinkedResponseIndex(T);    
            end
            indexToRefit = unique([location(found) linkedIndex]);
            % Which tests in the data are still the same - only do this for
            % two stage models.
            if numstages(T) > 1
                testsUnchanged = i_findSimilarTests(changes, oldSS, newSS);
            else
                testsUnchanged = zeros(0, 2);
            end
            % Update appropriate responses 
             children(T, indexToRefit, 'preorder', 'UpdateModel', 1, testsUnchanged);
        else
            % make default response models defined in test plan
            T = MakeResponseModels(T, MBrowser);
        end
    end    
    % make sure we have dynamic copy of test plan
    T = info(T);
    if T.ConstraintData~=0
        % delete all boundary models
        T.ConstraintData.delete;
        T.ConstraintData= xregpointer;
        xregpointer(T);
    end
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function T = i_modifyResponses(T, changes)
% Need to delete Responses that no longer have signals associated. These
% responses are stored in changes.ResponseSignalsFound. We must also remove
% those responses with invalid datum's
responsesToRemove = ~(changes.ResponseSignalsFound & changes.ResponseHasValidDatum);
% Lets delete the offending responses
if numChildren(T) > 0
    % Unfortuneatly we also need to remove the responses from the model 
    % browser, which isn't always going to exist. SO HACK put the graphical
    % deletion in a try catch to ensure that we can continue with the job
    % of really removing the responses
    responseIndex = find(responsesToRemove);
    try
        m = MBrowser;
        pResponsesToRemove = children(T, responseIndex);
        for i = 1:length(pResponsesToRemove)
            m.treeview(pResponsesToRemove(i), 'remove');
        end
    end
    children(T, responseIndex, 'delete');
    % NOTE - the deletion above modifies the heap copy of T so we need to
    % get up-to-date
    T = info(T);
else
    T.Responses(responsesToRemove) = [];
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function T = i_modifyMonitorVariables(T, changes)
% Need to remove the appropriate variable for the MonitorPlots holder -
% NOTE empty monitor field indicates nothing is being displayed
if ~isempty(T.Monitor) & changes.MONITOR_SIGNAL_REMOVED
    % Which y variables need to be removed
    monitorsToRemove = ismember(T.Monitor.values, changes.MonitorSignalsMissing);
    T.Monitor.values(monitorsToRemove) = [];
    % Remove the XData if it's missing
    if any(strcmp(T.Monitor.Xdata, changes.MonitorSignalsMissing))
        T.Monitor.Xdata = [];
    end
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function T = i_legacyPlotMemorySetup(T)
if ~isempty(T.PlotSetup)
    m= HSModel(T.DesignDev);
    mlist= getModel(T.DesignDev,':');
    
    
    ns= length(mlist);
    OK= size(T.PlotSetup.CrossSection,1) == nfactors(m) && length(T.PlotSetup.RespSurf)==ns;
    if OK 
        for i=1:ns
            OK = OK && nfactors(mlist{i}) == length(T.PlotSetup.RespSurf(i).Stage{1});
        end
    else
        OK= false;
    end
    if ~OK
        T= DefaultPlotSetup(T);
        msg= 'Response Surface and Cross-section settings reset';
    end
else
    T= DefaultPlotSetup(T);
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function matches = i_findSimilarTests(changes, oldSS, newSS)
% Default
matches = zeros(0, 2);
% First find any test which might be unchanged
oldGuids = getSweepGuids(oldSS);
newGuids = getSweepGuids(newSS);
[found, location] = ismember(oldGuids, newGuids);
% Did we find any similar guids?
if any(found)
    % Which variables do we need to check for changes
    varsToCheck = [changes.InputSignalsChanged changes.ResponseSignalsChanged];
    % Convert the found and location to valid indexes
    oldIndex = find(found);
    newIndex = location(found);
    % Reduce the size of the data - NOTE that oldSS and newSS should be the
    % same size since their guids were the same. However, just in case lets
    % put the rest of this in a try catch in case something went wrong
    try
        oldSS = oldSS(:, varsToCheck, oldIndex);
        newSS = newSS(:, varsToCheck, newIndex);
        % These 2 sweepsets should now contain sweeps with the same guids and
        % variables - lets look for any changed records 
        modifiedRecords = find(any(double(oldSS) ~= double(newSS), 2));
        % Need to check for no modified records as sweeppos can't deal with
        % this case correctly
        if isempty(modifiedRecords)
            logicalTestsModified = false(1, length(oldIndex));
        else
            % Convert this to sweeps 
            [dummy, logicalTestsModified] = sweeppos(oldSS, modifiedRecords);
        end
        % Find the index of unmodified tests
        unmodifiedIndex = find(~logicalTestsModified);
        % Create the matches return argument
        matches = zeros(length(unmodifiedIndex), 2);
        % And fill it with the correct indicies
        matches(:, 1) = oldIndex(unmodifiedIndex);
        matches(:, 2) = newIndex(unmodifiedIndex);
    end
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function T = i_assignMatch(T, pTSSF, newData)


% Matched Sweeps
T.DataLink= pTSSF;
% new sweepset data
newSS = sweepset( newData );
% Get the data pointers for the testplan
[Xp,Yp] = dataptr(T);

for Stage = 1:length(T.DesignDev)
	D = T.DesignDev(Stage);
	fNames= factorNames(D);
	Xdata= newSS(:,fNames);
		
	if Stage>1
		% use sweep means
		Xdata = smean(Xdata,Stage-1);
    else
        Xdata= sweepsetfilter(pTSSF);
        Xdata= addVarsFilter(Xdata,fNames);
        Xdata= setCacheState(Xdata, true);
	end
	
	% make a pointer array here 
	if length(Xp)<Stage 
		% need to augment pointer array
		Xp= [Xp xregpointer(Xdata)];
	elseif Xp(Stage)==0;
		% allocate some space
		Xp(Stage)= xregpointer(Xdata);
	else
		% reuse current location
		Xp(Stage).info= Xdata;
	end
	D= units( D,1, get(Xdata,'units') );
	T.DesignDev(Stage)= D;
end

if Yp~=0
    % data now stored as sweepset filter
    
    ySSF= sweepsetfilter(pTSSF);
    Ynames   = unique([children(T,'varname')';factorNames(T.DesignDev ,':')]);
    
    ySSF= addVarsFilter(ySSF,Ynames);
    ySSF= setCacheState(ySSF, true);

    % we should just get old data + any new factor signals
    Yp.info= ySSF;
    
else
    yData= sweepsetfilter(pTSSF);
    
	% add the x data initially
    yData= addVarsFilter(yData,factorNames(T.DesignDev ,':'));
    yData = updateCache(yData);

    Yp= xregpointer( yData );
end

% set matched flag if we have any data
T.Matched = size(newSS,1) ~= 0;

% assign data to testplan object
T= AssignData(T,{Xp,Yp});