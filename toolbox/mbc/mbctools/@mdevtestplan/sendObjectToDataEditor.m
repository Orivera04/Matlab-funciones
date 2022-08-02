function f = sendObjectToDataEditor(T, pSSF,oldTSSF)
%SENDOBJECTTODATAEDITOR Push a data object to the data editor
%
%  SENDOBJECTTODATAEDITOR(MP, PSSF)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.8.4 $    $Date: 2004/04/04 03:31:38 $ 

if nargin < 3
    oldTSSF = T.DataLink.info;
end
h = MBrowser;
% Open data edit facility
f = xregdataedit('create');
f.CloseClickedFcn = {@i_dataEditClose h T oldTSSF};
% Register as a subfigure
h.RegisterSubFigure(f);
% Make a copy of the object
tssf = pSSF.copy;
% Some legacy issues with data
if ~isempty( get(tssf,'reordersweeps') )
    % legacy issue as old tps used reordersweeps to define match
    tssf = reorderSweeps(tssf,Inf);
end
% Restore the object cache to speed up evaluation in the data editor
tssf = restoreCachedInfo(tssf);
% Ensure the object has it's data message service set
tssf = addMessageService(tssf, f.DataMessageService);
% Set the userdata of the figure
f.UserData.ObjectBeingEdited = pSSF;
% Set the new data object to a deep copy of the new data
f.DataMessageService.setDataObject(tssf);
% Set the read-only status of the data
f.DataMessageService.isReadOnly = false;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_dataEditClose(f, event, h, T, oldTSSF)
% Take a copy of the testplan as passed through so we could restore it
originalT = T;
% Make sure that testplan is uptodate
T = info(T);
CLOSE_DATA_EDITOR = ~event.LeaveVisible;
% Get the pointer being edited
pSSF = f.UserData.ObjectBeingEdited;
% Is the pointer location to copy back to still valid? - Clean up if not.
% After this section we can assume that we have a valid pointer. Don't know
% how this situation could arise but we'll keep this just in case!
if ~isvalid(pSSF)
    xregerror('Data Error', 'Data heap corruption - try recreating this testplan');
    % Close the data editor correctly
    i_closeDataEditor(f, CLOSE_DATA_EDITOR);
    % Update the view
    h.ViewNode;
    return
end  
newData = f.DataMessageService.DataObject;
% Ensure the new data is correctly unhooked from the editor
newData = removeMessageService(newData);
% Need to ensure that one stage testplans have one stage data - maybe
% in the long run 1 stage testplans will model the sweep mean of the
% response in which case this special test doesn't need to exist.
if numstages(T) == 1 && numstages(sweepset(newData)) ~= 1
    newData = modifyTestDefinition(newData, {'#rec' 1 false []});
end
% Apply the cluster settings to this copy - someone is going to want to
% know about the design inside.
newData = applyClusterSettings(newData);
% Before we un-cache the data lets ask what has happened to it
changes = pAssessDataChanges(T, newData);
% Get some strings to display in the dialog boxes that appear
[questMsg, busyStr] = i_createDialogStrings(T, changes);
% Split behaviour on INPUT_SIGNAL_REMOVED - can't really continue if this
% is the case with the new data - so choice is to revert to old data or cancel
if changes.INPUT_SIGNAL_REMOVED
    dlgopts = struct('Default', 'Cancel', 'Interpreter', 'tex');
    out = questdlg(questMsg, 'Data Selection', 'OK', 'Cancel', dlgopts);
    if strcmp(out, 'Cancel')
        % Cancel - bail straight back to the data editor
        return
    else
        % Indicate that changes are not to be accepted
        out = 'No';
    end
elseif ~isempty(questMsg)
    % Only ask the user if there is something to ask about!
    dlgopts = struct('Default', 'Yes', 'Interpreter', 'tex');
    out = questdlg(questMsg, 'Data Selection', 'Yes', 'No', 'Cancel', dlgopts);
    % Cancel - bail straight back to the data editor
    if strcmp(out,'Cancel')
        return
    end
else
    % Default - This means no discernable change has occured - Probably
    % ought to go for No but if we only refit different models
    out = 'Yes';
end

% Getting here indicates that the user clicked either yes or no, but not cancel
if CLOSE_DATA_EDITOR
    f.close;
end
drawnow('expose');

switch out
    case 'Yes'
        % Write the new data correctly into the project such that pSSF
        % now contains the new data
        try 
            T = modifyData(T, pSSF, newData, changes);
        catch
            Restore(T, originalT, oldTSSF);
            xregerror('Error updating testplan with new data.');
        end
        
    case 'No'
        Restore(T, originalT, oldTSSF);
end
% Update the view
h.ViewNode;
% Probably ought to update the listview with any changes to the treeview
h.listview;

% Free the inputs to the DataMessageService
freeInternalPtrs(f.DataMessageService.dataObject);


% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function [questMsg, busyMsg] = i_createDialogStrings(T, changes)
% We have 2 messages to set up - one that relates to the actual re-fit
% process and what is happening and one that is the question we ask the
% user to tell them what is going to happen
busyMsg = {};

% OK - What has happened to the data and how do we form the correct
% messages to the user? Need to take account of the current state of the
% testplan - it might not have any models yet

if changes.INPUT_SIGNAL_REMOVED
    % Worst case - An input signal has been removed and the user must
    % revert to the original testplan
    questMsg{1} = i_selectMessagePlurality( ...
        ['The model input signal %s is missing from the new data.  ', ...
        'This signal cannot be removed while it is being used in a model.'], ...
        ['The model input signals %s are missing from the new data.  ', ...
        'These signals cannot be removed while they are being used in a model.'], ...
        changes.InputSignalsMissing);
    questMsg{2} = '';
    questMsg{3} = 'Your changes will be discarded and the testplan will revert to using its previous data.';
    questMsg{4} = '';
else
    questMsg = {};
    if IsMatched(T)
        % Some response models might have to be removed and some refits
        % will probably have to occur
        if changes.RESPONSE_SIGNAL_REMOVED
            questMsg{end+1} = i_selectMessagePlurality( ...
                'Delete response model %s: the response signal is missing.', ...
                'Delete response models %s: the response signals are missing.', ...
                changes.ResponseSignalsMissing);
        end
        % Do any responses have missing datum's
        if ~isempty(changes.ResponseDatumMissing)
            questMsg{end+1} = i_selectMessagePlurality( ...
                'Delete response model %s: the datum model has been deleted.', ...
                'Delete response models %s: the datum model has been deleted.', ...
                changes.ResponseDatumMissing);
        end
        % We know that there are some responses left - what will the data
        % changes do to them
        if ~isempty(changes.ResponseSignalsChanged)
            if changes.INPUT_DATA_CHANGED
                questMsg{end+1} = 'Refit all response models: the input data has changed.';
            else
                questMsg{end+1} = i_selectMessagePlurality( ...
                'Refit response model %s: the response data has changed.', ...
                'Refit response models %s: the response data has changed.', ...
                changes.ResponseSignalsChanged);
            end
        end
    else
        if changes.RESPONSE_SIGNAL_REMOVED
            questMsg{end+1} = i_selectMessagePlurality( ...
                'Response model %s will not be built: the response signal is missing.', ...
                'Response models %s will not be built: the response signals are missing.', ...
                changes.ResponseSignalsMissing);
        end
        % Do any responses have missing datum's
        if ~isempty(changes.ResponseDatumMissing)
            questMsg{end+1} = i_selectMessagePlurality( ...
                'Response model %s will not be built: the datum model has been deleted.', ...
                'Response models %s will not be built: the datum model has been deleted.', ...
                changes.ResponseDatumMissing);
        end
        if ~isempty([changes.ResponseSignalsChanged changes.ResponseSignalsUnchanged]);
            
            questMsg{end+1} = i_selectMessagePlurality( ...
                'Build response model %s.', ...
                'Build response models %s.', ...
                [changes.ResponseSignalsChanged changes.ResponseSignalsUnchanged]);
        end
    end
    
    % Are we going to update the actual design
    if changes.ACTUAL_DESIGN_CHANGED
        questMsg{end+1} = 'Update the experimental design "Actual Design".';
    end

    % If anything has changed with the data or design then ask the user if they
    % want to accept the changes
    if ~isempty(questMsg)
        % Add a bullet point to all messages
        for n = 1:length(questMsg)
            questMsg{n} = ['\bullet ', questMsg{n}];
        end
        % Tag on a prefix intro and postfix question
        questMsg = [{'The following changes need to be made to the project:'}, ...
            {''}, ...
            questMsg, ...
            {''}, ...
            {'Do you want to make these changes?'}, ...
            {''}];
    end
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_closeDataEditor(f, CLOSE_DATA_EDITOR)
if CLOSE_DATA_EDITOR
    f.close;
end
drawnow('expose');
% Free the inputs to the DataMessageService
freeInternalPtrs(f.DataMessageService.dataObject);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function str = i_commaDelimit(strings)
% Escape any tex characters
strings = detex(strings);
if length(strings)==1
    str = strings{1};
else
    str = sprintf('%s, ', strings{1:end-1});  
    str = sprintf('%s and %s', str(1:end-2), strings{end});
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function str = i_selectMessagePlurality(singularMsg, pluralMsg, strings)
if length(strings)==1
    str = sprintf(singularMsg, i_commaDelimit(strings));
else
    str = sprintf(pluralMsg, i_commaDelimit(strings));
end
