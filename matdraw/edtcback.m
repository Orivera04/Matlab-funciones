function edtcback(command)

% EDTCBACK Callback for Edit Menu
% Function edtcback(prop)
% This is a callback function, and should not be
% called directly!
%
% Keith Rogers  1/95

% Mods:

%Copyright (c) 1997 by Keith Rogers

global MDDatObjs;

if(command == 1)

	selectList = MDDatObjs.SelectList;
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNDO:
%
% MDDatObjs.Undo holds an Nx3 matrix of objects, where
% N is the number of Undo actions to be taken. The
% first column holds the affected objects.  The 
% second column holds objects which contain the 
% affected properties in their UserData.  Here 
% the course of action can be indicated for cases 
% where the action to be undone was not a property.
% The third column contains objects which have in 
% their User Data the original values of the properties
% stored in the second column's objects.
%
% MDDatObjs.UndoClipboard is a secondary clipboard for undoing
% actions which affected the primary clipboard.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	UndoList = MDDatObjs.Undo;
	prop = UndoList(1).prop;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% UNDELETE and REPASTE
	% 1.  Unselect everything
	% 2.  Load Objects from UndoClipboard
	% 3.  Add them to the selectList
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if(strcmp(prop,'Undelete') | strcmp(prop,'RePaste'))
		if(strcmp(prop,'Undelete'))
			UClip = MDDatObjs.UndoClipboard;
		else
			UClip = MDDatObjs.Clipboard;
		end
		

		%%%%%%%%%%%%%%%%%%%%%%%
		% Unselect Everything %
		%%%%%%%%%%%%%%%%%%%%%%%

		unselect;

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Initialize new Select List %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% numItems is number of Items in clipboard %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		numItems = length(UClip);
		selectList = zeros(numItems,4);
		for(i=1:numItems)

		   %%%%%%%%%%%%%%%%%%%%%%%
		   % Restore the object! %
		   %%%%%%%%%%%%%%%%%%%%%%%

			obj = loadobj(UClip(i).command,UClip(i).data);

			%%%%%%%%%%%%%%%%%%%%
			% Set up Undo Info %
			%%%%%%%%%%%%%%%%%%%%

			UndoList(i).obj = obj;
			if(strcmp(prop,'Undelete') | strcmp(prop,'RePaste'))
				UndoList(i).prop = 'ReDelete';
			else
				UndoList(i).prop ='UnPaste';
			end

			%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Select loaded object(s) %
			%%%%%%%%%%%%%%%%%%%%%%%%%%%

			type = get(obj,'Type');
			if(strcmp(get(obj,'Selected'),'on'))
				if(strcmp(type,'line') | strcmp(type,'patch'))
					selectList(i,:) = [obj UClip(i).color];
				else
					selectList(i,:) = [obj 0 0 0];
				end
			end
		end

		MDDatObjs.Undo = UndoList;
		MDDatObjs.SelectList = selectList;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% REDELETE  and UNPASTE
	% 1.  For each object in UndoList
	%     a.  If it's selected, remove it from the selectList
	%     b.  Delete it.
	%     c.  (For Undoing Pastes) Copy Clipboard
	%         to Undo Clipboard
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	elseif(strcmp(prop,'ReDelete') | strcmp(prop,'UnPaste'))
		if(strcmp(prop,'UnPaste'))
			UndoList(1).prop = 'RePaste';
		else
			UndoList(1).prop = 'Undelete';
		end
		for(i=1:length(UndoList));
			if(any(UndoList(i).obj == selectList(:,1)))
				selectList = selectList(find(selectList(:,1)~=UndoList(i).obj));
			end
			delete(UndoList(i).obj);
		end
		MDDatObjs.Undo = UndoList(1);
		MDDatObjs.SelectList = selectList;
		
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% UNCUT
	% 1.  Move Clipboard to UndoClipboard
	% 2.  Move UndoClipboard to Clipboard
	% 3.  Unselect everything
	% 4.  Load Objects from UndoClipboard
	% 5.  Add them to the selectList
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	elseif(strcmp(prop,'UnCut'))
		UClip = MDDatObjs.Clipboard;
		MDDatObjs.Clipboard = MDDatObjs.UndoClipboard;
		MDDatObjs.UndoClipboard = UClip;
		unselect;
		selectList = zeros(size(UndoList,1),4);
		for(i=1:length(UClip))
			obj = loadobj(UClip(i).command,UClip(i).data);
			UndoList(i).obj = obj;
			UndoList(i).prop ='ReCut';
			type = get(obj,'type');
			if(strcmp(type,'line')|strcmp(type,'patch'))
				selectList(i,:) = [obj UClip(i).color];
			else
				selectList(i,:) = [obj 0 0 0];
			end
		end
		MDDatObjs.Undo = UndoList(1:i);
		MDDatObjs.SelectList = selectList;
		
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% RECUT
	% 1.  Move Clipboard to UndoClipboard
	% 2.  Move UndoClipboard to Clipboard
	% 3.  For each object in UndoList
	%     a.  If it's selected, remove it from the selectList
	%     b.  Delete it.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	elseif(strcmp(prop,'ReCut'))
		clipboard = MDDatObjs.UndoClipboard;
		MDDatObjs.UndoClipboard = MDDatObjs.Clipboard;
		MDDatObjs.Clipboard = clipboard;
		UndoList(1).prop = 'UnCut';
		for(i=1:length(UndoList))
			if(any(UndoList(i).obj == selectList(:,1)))
				selectList = selectList(find(selectList(:,1)~=UndoList(i).obj));
			end
			delete(UndoList(i).obj);
		end
		MDDatObjs.Undo = UndoList(1);
		MDDatObjs.SelectList = selectList;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%
	% If the property is 'Delete' then the object was
	% just created, and undoing it just means deleting
	% it. First, though, we have to copy the object 
	% into the undo clipboard. Also remember that
	% since we are undoing the creation of an object,
	% there is only one item to delete, so no loop
	% is necessary.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	elseif(strcmp(prop,'Delete'))
		selectList = MDDatObjs.SelectList;
		UClip = MDDatObjs.UndoClipboard;
		for(i=1:length(UndoList))
			if(any(UndoList(i).obj == selectList(:,1)))
				UClip(i).color = selectList(find(UndoList(i).obj==selectList),2:4);
				MDDatObjs.SelectList = MDDatObjs.selectList(find(UndoList(i).obj~=selectList),:);
			end
			[UClip(i).command,UClip(i).data] = saveobj(UndoList(i).obj);
		end
		delete(UndoList(:).obj);
		UndoList(1).prop = 'Undelete';
		MDDatObjs.Undo = UndoList(1);
		MDDatObjs.UndoClipboard = UClip(1:i);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%  Otherwise, just go through the list and undo 
	%  stuff. 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	else
		for(i=1:length(UndoList))
			prop = UndoList(i).prop;
			val = UndoList(i).val;
			curval = get(UndoList(i).obj,prop);
			set(UndoList(i).obj,prop,val);
			UndoList(i).val = curval;
		end
		MDDatObjs.Undo = UndoList;
	end
elseif(command == 2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CUT:
%  1: Set first Property in UndoList to "UnCut"
%  2: Copy clipboard to undo clipboard
%  3: Copy undo clipboard to clipboard
%  4: For each selected item:
%     a)  save it
%     b)  store the command and objects in clipboard
%     d)  delete it
%  6: Erase selectList and store UndoList and
%     clipboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	UndoList = MDDatObjs.Undo;
	UndoList(1).prop = 'UnCut';	
	clipboard = MDDatObjs.UndoClipboard;
	MDDatObjs.UndoClipboard = MDDatObjs.Clipboard;
	selectList = MDDatObjs.SelectList;
	
	for(i=1:size(selectList,1))
		[clipboard(i).command,clipboard(i).data] = saveobj(selectList(i,1));
		clipboard(i).color = selectList(i,2:4);
		delete(selectList(i,1));
	end
	
	MDDatObjs.SelectList = [];
	MDDatObjs.Undo = UndoList(1);
	MDDatObjs.Clipboard = clipboard(1:i);

elseif(command == 3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COPY:
%  1: Move clipboard to undo clipboard
%  2: Save selected objects to clipboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	selectList = MDDatObjs.SelectList;
	UndoList = MDDatObjs.Undo;
	UndoList(1).prop = 'Uncopy';
	clipboard = MDDatObjs.UndoClipboard;
	MDDatObjs.UndoClipboard = MDDatObjs.Clipboard;
	for(i=1:size(selectList,1))
		[clipboard(i).command,clipboard(i).data] = saveobj(selectList(i,1));
		clipboard(i).color = selectList(i,2:4);
	end
	MDDatObjs.Undo = UndoList(1);
	MDDatObjs.Clipboard = clipboard(1:i);

elseif(command == 4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PASTE:
% 1: Load objects in clipboard.
% 2: Deselect currently selected objects
% 3: Select objects that have been loaded.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	selectList = MDDatObjs.SelectList;
	UndoList = MDDatObjs.Undo;
	clipboard = MDDatObjs.Clipboard;
	unselect;
	selectList = zeros(size(clipboard,1),4);
	for(i=1:length(clipboard))
		selectList(i,1) = loadobj(clipboard(i).command,clipboard(i).data);
		selectList(i,2:4) = clipboard(i).color;
		UndoList(i).obj = selectList(i,1);
		UndoList(i).prop = 'UnPaste';
	end
	MDDatObjs.SelectList = selectList(1:i,:);
	MDDatObjs.Undo = UndoList(1:i);

elseif(command == 5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete:
%  1: Set first Property in UndoList to "Undelete" and
%     then terminate it.
%  2: For each selected item:
%     a)  save it
%     b)  store the command and objects in undoclipboard
%     d)  delete it
%  3: Terminate the undo clipboard
%  6: Erase selectList and store UndoList and
%     undo clipboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	selectList = MDDatObjs.SelectList;
	if(strcmp(get(selectList(1,1),'type'),'axes'))
		return;
	end
	UndoList = MDDatObjs.Undo;	
	UndoList(1).prop = 'Undelete';
	UClip = MDDatObjs.UndoClipboard;
	
	for(i=1:size(selectList,1))
		[UClip(i).command,UClip(i).data] = saveobj(selectList(i,1));
		UClip(i).color = selectList(i,2:4);
		delete(selectList(i,1));
	end
	MDDatObjs.SelectList = [];
	MDDatObjs.Undo = UndoList(1);
	MDDatObjs.UndoClipboard = UClip(1:i);
end
function unselect()
global MDDatObjs;
for(i=1:size(MDDatObjs.SelectList,1))
	if(ishandle(MDDatObjs.SelectList(i,1)))
		type = get(MDDatObjs.SelectList(i,1),'type');
		set(MDDatObjs.SelectList(i,1),'Selected','off');
		if(strcmp(type,'line'))
			set(MDDatObjs.SelectList(i,1),'Color',MDDatObjs.SelectList(i,2:4));
		elseif(strcmp(type,'patch'))
			if(MDDatObjs.SelectList(i,2) == -1)
				set(MDDatObjs.SelectList(i,1),'EdgeColor','none');
			elseif(MDDatObjs.SelectList(i,2) == -2)
				set(MDDatObjs.SelectList(i,1),'EdgeColor','flat');
			elseif(MDDatObjs.SelectList(i,2) == -3)
				set(MDDatObjs.SelectList(i,1),'EdgeColor','interp');
			else
				set(MDDatObjs.SelectList(i,1),'EdgeColor',MDDatObjs.SelectList(i,2:4));
			end						
		end
	end
end
