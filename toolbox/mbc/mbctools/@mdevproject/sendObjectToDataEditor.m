function f = sendObjectToDataEditor(MP, pSSF)
%SENDOBJECTTODATAEDITOR push a data object to the data editor
%
%  SENDOBJECTTODATAEDITOR(MP, PSSF)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.8.3 $    $Date: 2004/02/09 08:06:50 $ 

h = MBrowser;
% Open data edit facility
f = xregdataedit('create', 'CloseClickedFcn', {@i_dataEditClose h MP});
% Register as a subfigure
h.RegisterSubFigure(f);
% Make a copy of the object
ssf = pSSF.copy;
% Is this testplan data
IS_TESTPLAN_DATA = isTestplanData(MP, pSSF);
% If the object is a tssf then has it had it's clusters initialised
if IS_TESTPLAN_DATA & isempty(get(ssf, 'clusters'))
    if ~isempty( get(ssf,'reordersweeps') )
        % legacy issue as old tps used reordersweeps to define match
        ssf = reorderSweeps(ssf,Inf);
    end
    % Restore the object cache to speed up evaluation in the data editor
    ssf = restoreCachedInfo(ssf);
end
% Turn on the object's internal cacheing
ssf = setCacheState(ssf, true);
% Ensure the object has it's data message service set
ssf = addMessageService(ssf, f.DataMessageService);
% Set the userdata of the figure
f.UserData.ObjectBeingEdited = pSSF;
% Set the read-only status of the data if it is attached to a testplan
f.DataMessageService.isReadOnly = IS_TESTPLAN_DATA;
% Set the new data object to a deep copy of the new data
f.DataMessageService.setDataObject(ssf);
% Don't have to check for changes at the end if the data is read only
if IS_TESTPLAN_DATA
    f.CloseClickedFcn = {@i_readOnlyDataEditClose h MP};
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_dataEditClose(f, event, h, MP)
% Make sure that MP is uptodate
MP = info(MP);
% Which data pointer is being edited
pSSF = f.UserData.ObjectBeingEdited;
% Is the pointer location to copy back to still valid?
if isvalid(pSSF)
    % Get the old and new data
    oldData = pSSF.info;
    newData = f.DataMessageService.DataObject;
    % Ensure the new data is correctly unhooked from the editor
    newData = removeMessageService(newData);
    newData = setCacheState(newData, false);
    % Did the old data have anything in it?
    if isempty(oldData)
        OK = 'yes';
    else
        dispStr = 'Accept changes to data?';
        % Should we ask the user to confirm changes
        if isequal(oldData, newData)
            OK = 'yes';
        else
            OK = questdlg(dispStr, 'Data Changed', 'Yes', 'No', 'Cancel', 'No');
        end
    end

    switch lower(OK)
        case 'cancel'
            return
        case 'yes'
            modifyData(MP, pSSF, newData);
    end
end
% Free the inputs to the DataMessageService
freeInternalPtrs(f.DataMessageService.dataObject);
if ~event.LeaveVisible
    % Close the data editor
    f.close;
end
% Update the view
h.ViewNode;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_readOnlyDataEditClose(f, event, h, MP)
% Free the inputs to the DataMessageService
freeInternalPtrs(f.DataMessageService.dataObject);
% Have we been asked to leave the data editor visible
if ~event.LeaveVisible
    % Close the data editor
    f.close;
end
