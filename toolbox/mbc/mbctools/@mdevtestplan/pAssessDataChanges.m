function out = pAssessDataChanges(T, newData)
%PASSESSDATACHANGES work out what has changed in the testplan data
%
%  PASSESSDATACHANGES(T, NEWTSSF, OLDTSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:31:36 $ 

% Create the output structure to indicate the changes
out = struct(...
    'INPUT_SIGNAL_REMOVED', false,...
    'RESPONSE_SIGNAL_REMOVED', false,...
    'MONITOR_SIGNAL_REMOVED', false,...
    'ACTUAL_DESIGN_CHANGED', false,...
    'INPUT_DATA_CHANGED', false,...
    'RESPONSE_DATA_CHANGED', false,...
    'DATA_CHANGED', false,...
    'InputSignalsFound', [],...
    'InputSignalsMissing', {{}},...
    'InputSignalsChanged', {{}},...
    'InputSignalsUnchanged', {{}},...
    'ResponseSignalsFound', [],...
    'ResponseHasValidDatum', [],...
    'ResponseSignalsMissing', {{}},...
    'ResponseDatumMissing', {{}},...
    'ResponseSignalsChanged', {{}},...
    'ResponseSignalsUnchanged', {{}},...
    'MonitorSignalsMissing', {{}},...
    'OldData', []);
% Some definitions ...
% nI is the number of inputs to the testplan
% nR is the number of current or pending responses in the testplan
% INPUT_SIGNAL_REMOVED     - logical : An input signal is missing or of zero length
% RESPONSE_SIGNAL_REMOVED  - logical : A response signal is missing or of zero length
% MONITOR_SIGNAL_REMOVED   - logical : A monitor signal is missing or of zero length
% ACTUAL_DESIGN_CHANGED    - logical : The ActualDesign has changed
% INPUT_DATA_CHANGED       - logical : An input signal is different (value or test)
% RESPONSE_DATA_CHANGED    - logical : A response signal is different (value or test)
% DATA_CHANGED             - logical : The data is different
% InputSignalsFound        - Logical array (1xnI) : Input signals that exist.
% InputSignalsMissing      - Cell array of string : Signals missing
% InputSignalsChanged      - Cell array of string : Signals changed
% InputSignalsUnchanged    - Cell array of string : Signals that are the same
% ResponseSignalsFound     - Logical array (1xnR) : Response signals that exist.
% ResponseHasValidDatum    - Logical array (1xnR) : Response signals that have a valid datum
% ResponseSignalsMissing   - Cell array of string : Signals missing
% ResponseDatumMissing     - Cell array of string : Datum missing
% ResponseSignalsChanged   - Cell array of string : Signals changed
% ResponseSignalsUnchanged - Cell array of string : Signals that are the same
% MonitorSignalsMissing    - Cell array of string : Signals missing


% Get the old and new data - need to deal carefully with the case where the
% testplan is unmatched as oldData isn't what was previously in the testplan
if IsMatched(T)
    out.OldData = T.DataLink.info;
else
    out.OldData = testplansweepsetfilter;
end

% Convert to sweepsets as we aren't actually interesed in much from
% the tssf itself - will look at the ActualDesign in a minute
newSS = sweepset(newData);
oldSS = sweepset(out.OldData);

% Get the new siganl names
newNames = get(newSS, 'name');

% Get the important signals for this testplan
inputSignalNames = factorNames(designdev(T));
responseSignalNames = i_getResponseNames(T);
% Remember monitor isnt always a structure and T.Monitor.values might be
% empty
if ~isempty(T.Monitor) && ~isempty(T.Monitor.values)
    monitorSignalNames = unique([T.Monitor.values ;  T.Monitor.Xdata]);
else
    monitorSignalNames = {};
end

SIGNALS_FOUND = size(newSS, 1) > 0;
% Which signals still exist - no data in an input signal is as bad as the
% signal itself being missing
inputSignalsFound    = ismember(inputSignalNames, newNames) & SIGNALS_FOUND;
responseSignalsFound = ismember(responseSignalNames, newNames) & SIGNALS_FOUND;
monitorSignalsFound  = ismember(monitorSignalNames, newNames) & SIGNALS_FOUND;

out.INPUT_SIGNAL_REMOVED    = ~all(inputSignalsFound);
out.RESPONSE_SIGNAL_REMOVED = ~all(responseSignalsFound);
out.MONITOR_SIGNAL_REMOVED  = ~all(monitorSignalsFound);

out.InputSignalsMissing     = inputSignalNames(~inputSignalsFound);
out.ResponseSignalsMissing  = responseSignalNames(~responseSignalsFound);
out.MonitorSignalsMissing   = monitorSignalNames(~monitorSignalsFound);


responseHasValidDatum = responseSignalsFound;
% Which responses will need to be removed because a datum response is being
% deleted - NOTE that the datum response is ALWAYS the first response
if length(responseSignalsFound) > 0 & ~responseSignalsFound(1) 
    % Which other responses need to be removed
    linkedIndex = getDatumLinkedResponseIndex(T);    
    responseHasValidDatum(linkedIndex) = false;
    out.ResponseDatumMissing = responseSignalNames(linkedIndex);
end

out.InputSignalsFound = inputSignalsFound;
out.ResponseSignalsFound = responseSignalsFound;
out.ResponseHasValidDatum = responseHasValidDatum;

% Check for tests changing - this constitutes a change to the data that
% will not be picked up by an isequal(double, double) test and which does
% represent a very real modification 
TESTS_CHANGED = ~isequal(getGuids(oldSS), getGuids(newSS)) | ...
    ~isequal(getSweepGuids(oldSS), getSweepGuids(newSS));

out.DATA_CHANGED = TESTS_CHANGED | ~isequalwithequalnans(double(oldSS), double(newSS));

% Has the actual design changed
newDesign = get(newData, 'codeddesign');
oldDesign = ActualDesign(T);
out.ACTUAL_DESIGN_CHANGED = ~isequal(factorsettings(oldDesign), factorsettings(newDesign));

% A base assumption for the rest of this code is that all named signals
% exist in the oldSS - this is not the case when oldSS is empty, as in the
% initialisation of the test plan. If this is the case then we need to fill
% in the extra fields appropriately. NOTE the initialisation will occur
% when T is not matched
if ~IsMatched(T)
    out.INPUT_DATA_CHANGED = true;
    out.RESPONSE_DATA_CHANGED = true;
    out.InputSignalsChanged = inputSignalNames(inputSignalsFound);
    out.ResponseSignalsChanged = responseSignalNames(responseSignalsFound & responseHasValidDatum);
    return
end

% Check the input data for consistency
dblInOld = double(oldSS(:, inputSignalNames(inputSignalsFound)));
dblInNew = double(newSS(:, inputSignalNames(inputSignalsFound)));
out.INPUT_DATA_CHANGED = out.INPUT_SIGNAL_REMOVED | TESTS_CHANGED | ~isequalwithequalnans(dblInOld, dblInNew);

if out.INPUT_DATA_CHANGED
    % Which inputs have been changed
    for i = 1:length(inputSignalNames)
        % Only check inputs that have been found
        if inputSignalsFound(i)
            % Calculate index into the available input data
            thisIndex = sum(inputSignalsFound(1:i));
            % Are the values different
            if TESTS_CHANGED | ~isequalwithequalnans(dblInOld(:, thisIndex), dblInNew(:, thisIndex))
                out.InputSignalsChanged(end+1) = inputSignalNames(i);
            else
                out.InputSignalsUnchanged(end+1) = inputSignalNames(i);
            end
        end
    end
else
    % No changes to the input signals mean that they must all be unchanged
    out.InputSignalsUnchanged = inputSignalNames;
end

% Implicit change to a response if the input data has changed
dblRespOld = double(oldSS(:, responseSignalNames(responseSignalsFound)));
dblRespNew = double(newSS(:, responseSignalNames(responseSignalsFound)));
out.RESPONSE_DATA_CHANGED = out.RESPONSE_SIGNAL_REMOVED | out.INPUT_DATA_CHANGED | ~isequalwithequalnans(dblRespOld, dblRespNew);

if out.RESPONSE_DATA_CHANGED
    % Which responses have been changed
    for i = 1:length(responseSignalNames)
        % Only check responses that have been found and have valid DATUM's
        if responseSignalsFound(i) & responseHasValidDatum(i)
            % Calculate index into the available input data
            thisIndex = sum(responseSignalsFound(1:i));
            % Is their data different - note implicit change if INPUT_DATA_CHANGED        
            if out.INPUT_DATA_CHANGED | ~isequalwithequalnans(dblRespOld(:, thisIndex), dblRespNew(:, thisIndex))
                out.ResponseSignalsChanged{end+1} = responseSignalNames{i};
            else
                out.ResponseSignalsUnchanged{end+1} = responseSignalNames{i};
            end
        end
    end
else
    % No changes to the response signals mean that they must all be unchanged
    out.ResponseSignalsUnchanged = responseSignalNames;
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [responseNames, models] = i_getResponseNames(T)
% Default is no responces
responseNames = {};
models = {};
% Responses are either the children of a testplan or they have yet to be
% built and reside in the Response field of the testplan
if numChildren(T) > 0
    responseNames = children(T, 'varname');
    models = children(T, 'model');
else
    for i = 1:length(T.Responses)
        responseNames{i}= varname(T.Responses{i});
    end
    models = T.Responses;
end