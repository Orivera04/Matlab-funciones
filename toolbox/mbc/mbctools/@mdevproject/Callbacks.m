function h=Callbacks(TP,subfunc,varargin)
% CALLBACKS  Various tesplan GUI callbacks
%
%   Callbacks(TP, 'GetHandles') returns a cell array of function handles
%   to subfunctions available:
%
%     {}
%
%   Callbacks(TP, FUNC, ARGS) executes the iternal function FUNC and passes
%   it ARGS
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.8.4.4 $  $Date: 2004/04/04 03:31:22 $




h=[];
if ischar(subfunc)
	switch(lower(subfunc))
	case 'gettoolbarhandles'
		h={@i_NewData;@i_CopyData;@i_EditData;@i_DeleteData;@i_NewNote;@i_viewMenuState;@i_switchtips;@i_setupNotesList};
	case 'newdata'
		i_NewData(varargin{:});
	case 'editdata'
		i_EditData(varargin{:});
	case 'deletedata'
		i_DeleteData(varargin{:});
	case 'copydata'
		i_CopyData(varargin{:});
	case 'changelabel'
		i_ChangeLabel(varargin{:});
	case 'newnote'
		i_NewNote(varargin{:});
	case 'afternoteedit'
		i_AfterNoteEdit(varargin{:});
	case 'deletenote'
		i_DeleteNote(varargin{:});
	end
else
	feval(subfunc,varargin{:});   
end
return


% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_NewNote(src, evt)
[h, MP, View] = i_getView;

usr = initfromprefs(mbcuser);
% update the file history
MP.History= [MP.History struct('User',usr,'Action','','Date',now)];
pointer(MP);

note = View.noteList.ListItems.Add;
prfs = getpref(mbcprefs('mbc'),'mdevproject');
colstoshow = prfs.NotesListColumns;
if colstoshow(1)
   note.Text = '';
end
col = 1;
if colstoshow(2)
   set(note, 'SubItems', col, getusername(usr));
   col = col+1;
end
if colstoshow(3)
   set(note, 'SubItems', col, getcompany(usr));
   col = col+1;
end
if colstoshow(4)
   set(note, 'SubItems', col, getdepartment(usr));
   col = col+1;
end
if colstoshow(5)
   set(note, 'SubItems', col, getcontact(usr));
   col = col+1;
end
if colstoshow(6)
   set(note, 'SubItems', col, datestr(now,1));
   col = col+1;
end
if colstoshow(7)
   set(note, 'SubItems', col, datestr(now,16));
   col = col+1;
end
note.Selected = 1;
note.SmallIcon = 1;
View.noteList.StartLabelEdit;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_DeleteNote(src,evt)
[h, MP, View] = i_getView;

ind = i_getListboxIndex(View.noteList);
if (ind < 1) || (ind > length(MP.History))
	return
end
editInd = getEditableNoteIndicies(MP);
if ismember(ind, editInd)
	MP.History(ind) = [];
	pointer(MP);
	h.ViewNode;
end


% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_NewData(src,evt)
[h, MP, View] = i_getView;
set(h.figure,'pointer','watch')
% Create a viable sweepsetfilter object
[MP, pSSF] = createDataObject(MP);
% Update the listview on the project page
h.ViewNode;
% Send the new data to the data editor
sendObjectToDataEditor(MP, pSSF);
% Change the watch back
set(h.figure,'pointer','arrow')

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_EditData(src,event)
[h, MP, View] = i_getView;
% Catch invalid double clicks
ind = i_getListboxIndex(View.dataList);
if (ind < 1) || (ind > length(MP.Datalist))
	return
end
% Get the selected data entry
pSSF = MP.Datalist(ind);
% This might take a while
set(h.figure,'pointer','watch')
% Send the new data to the data editor
sendObjectToDataEditor(MP, pSSF);
% Change the watch back
set(h.figure,'pointer','arrow')

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_CopyData(src,event)
[h, MP, View] = i_getView;
set(h.figure,'pointer','watch')
% Which dataset are we copying
ind = i_getListboxIndex(View.dataList);
pSSF = MP.Datalist(ind);
% Duplicate the appropriate dataset
pcSSF = xregpointer(pSSF.info);
% May need to cast to the correct data type
if isTestplanData(MP, pSSF)
    pcSSF.info = pcSSF.sweepsetfilter;
end
% Change label after casting to ssf to ensure the testplan bit is removed
pcSSF.info = pcSSF.set('label',  ['Copy of ' pcSSF.get('label')]);
% Update the project datalist with the new sweepset object
addData(MP, pcSSF);
% Make sure the datalist listbox is up to date
h.ViewNode;
% Send the new data to the data editor
sendObjectToDataEditor(MP, pcSSF);
% Change the watch back
set(h.figure,'pointer','arrow')

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_DeleteData(src,evt)
[h, MP, View] = i_getView;

ind = i_getListboxIndex(View.dataList);
if ind < 1 || ind > length(MP.Datalist)
	return
end

% Get the pointer to the data object being deleted
pSSF = MP.Datalist(ind);
% Can we really delete this data
if isTestplanData(MP, pSSF)
    uiwait(warndlg('Testplan data will be deleted when the associated testplan is deleted','Error Deleteing Data','modal'));    
    return
end
% Data is not associated with a testplan and hence can safely be deleted -
% does the user really mean it?
answer = questdlg('Delete data object', 'Delete data', 'OK', 'Cancel', 'Cancel');
if ~strcmpi(answer, 'ok')
    return
end
% Remove the data from the project
MP = removeData(MP, pSSF);
% Get the data editor
f = xregdataedit('gethandle');
% May need to close the data editor if this object is being edited
if ~isempty(f) && ishandle(f) && f.UserData.ObjectBeingEdited == pSSF
    % Free the internal of the object in the data message service
    freeInternalPtrs(f.DataMessageService.dataObject);
    % Close the editor
	f.close;
end
% Update the view
h.ViewNode;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_ChangeLabel(newName)
[h, MP, View] = i_getView;
% Which dataset are we copying
ind = i_getListboxIndex(View.dataList);
pSSF = MP.Datalist(ind);
% Change the label
pSSF.info = pSSF.set('label', getValidDataName(MP, newName));
% Update the listbox
h.ViewNode;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_AfterNoteEdit(newNote)
[h, MP, View] = i_getView;
ind = i_getListboxIndex(View.noteList);
editInd = getEditableNoteIndicies(MP);
if ismember(ind, editInd)
   usr = initfromprefs(mbcuser);
	MP.History(ind) = struct('User', usr, 'Action', newNote, 'Date', now);
	pointer(MP);
end
h.ViewNode;

% --------------------------------------------------------------------
% Function i_getListboxIndex
%
% Internal function to find the index of the selected item in the listbox
% --------------------------------------------------------------------
function index = i_getListboxIndex(Listbox)

index = -1;
if Listbox.ListItems.count > 0
	% Cast return from activeX control to be a double
	index = double(Listbox.SelectedItemIndex);
	if nargin == 1
		index = index(1);
	end
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function [h, MP, View] = i_getView
% Get the mdevproject node
h = MBrowser;
View = h.GetViewData;
MP = h.CurrentNode.info;


% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_viewMenuState(src,evt,lyt,mnTips)
st = get(lyt,'state');
if strcmp(st,'center')
   set(mnTips,'checked','on');
else
   set(mnTips,'checked','off');
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_switchtips(src,evt,lyt)
mbH = MBrowser;
View = mbH.GetViewData;
state = get(src,'checked');
if strcmp(state,'off')
   state = 'on';
   lytstate='center';
else
   state = 'off';
   lytstate='right';
end
set(src,'checked',state);
set(View.layout,'state',lytstate);


function i_setupNotesList(src,evt)
mbH = MBrowser;
nd = mbH.CurrentNode;
prfs = getpref(mbcprefs('mbc'),'mdevproject');
old_colstoshow = prfs.NotesListColumns;

% Call a method to edit the columns-viewed preference
gui_notessetup(nd.info);

% check whether any settings have changed
prfs = getpref(mbcprefs('mbc'),'mdevproject');
colstoshow = prfs.NotesListColumns;
if any(colstoshow~=old_colstoshow)
   % check list columns are correct
   View = mbH.GetViewData;
   hCols = View.noteList.ColumnHeaders;
   cols = {'Note' 'User' 'Company' 'Department' 'Contact Information' 'Date' 'Time'};
   width = [400 100 100 100 100 75 75];
   
   hCols.Clear;
   for k = find(colstoshow)
      hItem = hCols.Add;
      hItem.Text = cols{k};
      hItem.Width = width(k);
   end
   
   % update gui
   mbH.ViewNode;
end
