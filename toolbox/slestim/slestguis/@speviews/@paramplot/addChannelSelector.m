function h = addChannelSelector(this)
% Builds row selector for parameter plot.

%   Author(s): P. Gahinet
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:15 $
nr = length(this.ChannelName);
RowNames = this.ChannelName;
for ct=1:nr
   if length(RowNames{ct})>20
      RowNames{ct} = [RowNames{ct}(1:18) '..'];
   end
end

% Build selector
h = speviews.paramselector(this,...
   'RowName',this.ChannelName,...
   'RowSelection',strcmp(this.ChannelVisible,'on'));

% Center dialog
centerfig(h.Handles.Figure,this.AxesGrid.Parent);

% Install listeners that keep selector and parameter plot in sync
L1 = [handle.listener(h,h.findprop('RowSelection'),'PropertyPostSet',{@LocalSetRCVisible this});...
      handle.listener(this,this.findprop('ChannelVisible'),'PropertyPostSet',{@LocalSetSelection h})];
L2 = [handle.listener(this,'ObjectBeingDestroyed',@LocalDelete);...
      handle.listener(this,this.findprop('Visible'),'PropertyPostSet',@LocalSetVisible)];
set(L2,'CallbackTarget',h);
h.addlisteners([L1;L2])

%------------------ Local Functions -------------------------------

function LocalSetRCVisible(eventsrc,eventdata,this)
OnOff = {'off','on'};
this.ChannelVisible = OnOff(1+eventdata.NewValue);

function LocalSetSelection(eventsrc,eventdata,h)
h.RowSelection = strcmp(eventdata.NewValue,'on');

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

