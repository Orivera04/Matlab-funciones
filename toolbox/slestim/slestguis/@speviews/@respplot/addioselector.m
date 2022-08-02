function h = addioselector(this)
%ADDIOSELECTOR  Builds I/O selector for response plot.

%   Author(s): P. Gahinet
%   Copyright 1986-2002 The MathWorks, Inc. 
%   $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:09 $
[OutPortNames,ExpNames] = getrcname(this);
PortNames = utGetPortName(OutPortNames);
ni = length(ExpNames);
no = length(PortNames);

% Build selector
h = ctrluis.axesselector(max(1,[no ni]),...
   'Name','Row/Column Selector',...
   'RowName',PortNames,...
   'ColumnName',ExpNames);

% Center dialog
centerfig(h.Handles.Figure,this.AxesGrid.Parent);

% Install listeners that keep selector and response plot in sync
p1 = [h.findprop('RowSelection');h.findprop('ColumnSelection')];
p2 = [this.findprop('InputVisible');this.findprop('OutputVisible')];
L1 = [handle.listener(h,p1,'PropertyPostSet',{@LocalSetIOVisible this});...
      handle.listener(this,p2,'PropertyPostSet',{@LocalSetSelection h})];
L2 = [handle.listener(this,'ObjectBeingDestroyed',@LocalDelete);...
      handle.listener(this,this.findprop('Visible'),'PropertyPostSet',@LocalSetVisible)];
set(L2,'CallbackTarget',h);
h.addlisteners([L1;L2])

%------------------ Local Functions -------------------------------

function LocalSetIOVisible(eventsrc,eventdata,this)
OnOff = {'off','on'};
switch eventsrc.Name
case 'RowSelection'
   this.OutputVisible = OnOff(1+eventdata.NewValue);
case 'ColumnSelection'
   this.InputVisible = OnOff(1+eventdata.NewValue);
end

function LocalSetSelection(eventsrc,eventdata,h)
switch eventsrc.Name
case 'OutputVisible'
   h.RowSelection = strcmp(eventdata.NewValue,'on');
case 'InputVisible'
   h.ColumnSelection = strcmp(eventdata.NewValue,'on');
end

function LocalDelete(h,eventdata)
if ishandle(h.Handles.Figure)
   delete(h.Handles.Figure)
end
delete(h)

function LocalSetVisible(h,eventdata)
% REVISIT: push/pop would be better
if strcmp(eventdata.NewValue,'off')
   h.Visible = 'off';
end
