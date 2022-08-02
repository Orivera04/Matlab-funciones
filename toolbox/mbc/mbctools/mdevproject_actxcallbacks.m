function mdevproject_actxcallbacks(obj, eventType, varargin)
%MDEVPROJECT_ACTXCALLBACKS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.4 $  $Date: 2004/04/04 03:32:45 $

% Define meaningful ActiveX CONSTANTS
AFTER_LABEL_EDIT = 9;
DBL_CLICK = 2;
KEY_UP = 5;

DELETE_KEY = 46;
INSERT_KEY = 45;
F2_KEY = 113;

mbh = MBrowser;
pMP = mbh.RootNode;

% Which control sent the event?
switch lower(obj.userdata)
case 'datalist'
	switch eventType
	case AFTER_LABEL_EDIT
		newName = varargin{2};
		pMP.Callbacks('ChangeLabel', newName);
	case DBL_CLICK
		pMP.Callbacks('EditData');
	case KEY_UP
		% DELETE key can only be caught with a keuUp event, not a keyPressed event
		keyPressed = double(varargin{1});
		switch keyPressed
		case DELETE_KEY
			pMP.Callbacks('DeleteData');
		case INSERT_KEY
			pMP.Callbacks('NewData');
		case F2_KEY
         obj.StartLabelEdit;
		end
	end
case 'notelist'
	switch eventType
	case AFTER_LABEL_EDIT
		newNote = varargin{2};
		pMP.Callbacks('AfterNoteEdit', newNote);
	case KEY_UP
		% DELETE key can only be caught with a keuUp event, not a keyPressed event
		keyPressed = double(varargin{1});
		switch keyPressed
		case INSERT_KEY
			pMP.Callbacks('NewNote');
		case DELETE_KEY
			pMP.Callbacks('DeleteNote');
		case F2_KEY
         obj.StartLabelEdit;
		end
	end
end
