function edit(this,PropEdit)
%EDIT  Configures Property Editor for response plots.

%   Author(s): A. DiVergilio, P. Gahinet
%   Copyright 1986-2002 The MathWorks, Inc. 
%   $Revision: 1.1.4.1 $  $Date: 2004/04/16 22:21:11 $

AxGrid = this.AxesGrid;
Tabs = PropEdit.Tabs;

% Labels tab
LabelBox = this.editLabels('Labels',Tabs(1).Contents);
Tabs(1) = PropEdit.buildtab(Tabs(1),LabelBox);

% Limits tab
XlimBox = AxGrid.editLimits('X','X-Limits',Tabs(2).Contents);
YlimBox = this.editYlims(Tabs(2).Contents);
LocalCustomizeLimBox([],[],AxGrid,XlimBox,YlimBox); % @respplot customization
Tabs(2) = PropEdit.buildtab(Tabs(2),[XlimBox;YlimBox]);

% Style
AxStyle  = AxGrid.AxesStyle;
GridBox  = AxGrid.editGrid('Grid' ,Tabs(3).Contents);
FontBox  = this.editFont('Fonts',Tabs(3).Contents);
ColorBox = AxStyle.editColors('Colors',Tabs(3).Contents);
Tabs(4)  = PropEdit.buildtab(Tabs(3),[GridBox;FontBox;ColorBox]);

set(PropEdit.Java.Frame,'Title',...
   sprintf('Property Editor: %s',this.AxesGrid.Title));
PropEdit.Tabs = Tabs;

%------------------- Local Functions ------------------------------

function LocalCustomizeLimBox(eventsrc,eventdata,AxGrid,XlimBox,YlimBox)
% Customizes X-Limits and Y-Limits tabs
AxSize = [AxGrid.Size 1 1];
% Input selector
s = get(XlimBox.GroupBox,'UserData'); % Java handles
XSelect = (~isempty(s.RCSelect.getParent));
if XSelect
   s.RCLabel.setText(sprintf('Input:'))
   % Populate input selector
   RCLabels = strrep(AxGrid.ColumnLabel,'From: ','');
   LocalShowIOList(s.RCSelect,RCLabels(1:AxSize(4):end),AxSize(2))
end   

% Output selector
s = get(YlimBox.GroupBox,'UserData'); % Java handles
YSelect = (~isempty(s.RCSelect.getParent));
if YSelect
   s.RCLabel.setText(sprintf('Output:'))
   RCLabels = strrep(AxGrid.RowLabel,'To: ','');
   LocalShowIOList(s.RCSelect,RCLabels(1:AxSize(3):end),AxSize(1))
end

% Related listeners
if isempty(eventsrc) & (XSelect | YSelect)
   labprop = [findprop(AxGrid,'ColumnLabel'),findprop(AxGrid,'RowLabel')];
   L = handle.listener(AxGrid,labprop,...
      'PropertyPostSet',{@LocalCustomizeLimBox AxGrid XlimBox YlimBox});
   XlimBox.TargetListeners = [XlimBox.TargetListeners ; L];
end


%%%%%%%%%%%%%%%%%%%
% LocalShowIOList %
%%%%%%%%%%%%%%%%%%%
function LocalShowIOList(RCSelect,RCLabels,RCSize)
% Builds I/O lists for X- and Y-limit tabs
n = RCSelect.getSelectedIndex;
RCSelect.removeAll;
RCSelect.addItem(sprintf('all'));
for ct=1:length(RCLabels)
   RCSelect.addItem(sprintf('%s',RCLabels{ct}));
end
RCSelect.select(n);

