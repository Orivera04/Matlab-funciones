function View=View(MP, mbH, View)
% VIEW Update current view
%
%  View=View(P, mbH, View)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.8.4.2 $  $Date: 2004/02/09 08:06:54 $



% Create 10/4/2001

i_updateDataList(View, MP);
i_updateNoteList(View, MP);

if length(MP.Datalist) > 0
	state = 'on';
else
	state = 'off';
end
set(View.toolbarBtns(2:3), 'enable', state);
set(View.toolsMenuItems(2:4), 'enable', state);

return


%----------------------------------------------------------------------------
%
%----------------------------------------------------------------------------
function i_updateDataList(View, MP)
currSel = 0;
if View.dataList.ListItems.Count > 0
   currSel = View.dataList.SelectedItemIndex;
end

View.dataList.ListItems.Clear;
for i = 1:length(MP.Datalist)
   item = View.dataList.ListItems.Add;
   data = MP.Datalist(i).info;
   sz = size(data);
   item.Text = get(data, 'label');
   set(item, 'SubItems', 1, sprintf('%d',sz(1)));
   set(item, 'SubItems', 2, sprintf('%d',sz(2)));
   set(item, 'SubItems', 3, sprintf('%d',sz(3)));
   
   lockNode = isTestplanData(MP, MP.Datalist(i));
   item.SmallIcon = lockNode + 1;
   set(View.dataList, 'NodeLocked', i, double(lockNode));
   if i == currSel
      item.selected = 1;
      EnsureVisible(item);
   end
end

%----------------------------------------------------------------------------
%
%----------------------------------------------------------------------------
function i_updateNoteList(View, MP)
currSel = 0;
if View.noteList.ListItems.count > 0
   currSel = View.noteList.SelectedItemIndex;
end
ind = getEditableNoteIndicies(MP);
prfs = getpref(mbcprefs('mbc'),'mdevproject');
colstoshow = prfs.NotesListColumns;
View.noteList.ListItems.Clear;
for i = 1:length(MP.History)
   note = View.noteList.ListItems.Add;
   usr = MP.History(i).User;
   if colstoshow(1)
      note.Text = MP.History(i).Action;
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
      set(note, 'SubItems', col, datestr(MP.History(i).Date,1));
      col = col+1;
   end
   if colstoshow(7)
      set(note, 'SubItems', col, datestr(MP.History(i).Date,16));
      col = col+1;
   end
   lockNode = ~ismember(i, ind);
   note.SmallIcon = lockNode + 1;
   set(View.noteList, 'NodeLocked', i, double(lockNode));
   if i == currSel
      note.Selected = 1;
      EnsureVisible(note);
   end
end
