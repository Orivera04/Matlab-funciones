%DD_EXAMPLE5       Drag and Drop Example 5: Dragging enabled uicontrols
% All of the earlier examples demonstrated dragging pushbuttons and axes.
% The pushbuttons are disabled, meaning the user can't actually push the
% button.  This example shows how to drag from enabled uicontrols.  This is
% useful for instance for popupmenus and listboxes, where the user makes a
% selection before dragging.  
%
% A challenge arises when using enabled uicontrols, since MATLAB won't know
% if the user is trying to interact with a control (selecting a value, for
% instance) or if she's trying to drag the control.  MATLAB can not
% differentiate between clicking and click-and-dragging.  The uicontrols
% primary action always takes precedence.  This leaves two ways to drag an
% enabled uicontrol - either left-click on it's border, or right-click
% anywhere on the control.
%
% There is one additional, related trick.  If a uicontrol sits on top of
% another (a frame, for instance), clicking on the border of the control is
% actually registered as a hit on the lower control.  We get around this by
% making the lower control inactive.

%Drag and drop to create plots
%2 Axes: top is 2D, bottom is 3D
clear;close all
hFig = figure('Position',[200 300 500 400]);
frm1 = uicontrol('style','frame','pos',[15 235 90 140],'Enable','inactive');
strg1 = uicontrol('style','text','pos',[17 320 86 40],'String','Drag To Axis for 3D plots','Enable','inactive');
drag1 = uicontrol('Style','popupmenu','pos',[20 240 80 20],'String',{'U','V','W'});

frm2 = uicontrol('style','frame','pos',[15 15 90 140],'Enable','inactive');
strg2 = uicontrol('style','text','pos',[17 100 86 40],'String','Drag To Axis for 2D plots','Enable','inactive');
drag2 = uicontrol('Style','listbox','pos',[20 20 80 80],'String',{'var1','var2','var3'});
set(drag2,'Max',10,'Min',0);    %Enable multiple selection

drop1 = axes('Position',[.3 .11 .6 .7]);

uicontrol('style','text','pos',[120 375 350 20],'String','To drag, left-click on border, or right-click anywhere on control.', ...
    'Enable','inactive');


%Store some data in the figure for plotting.  
load wind
U = squeeze(u(:,:,7));
V = squeeze(v(:,:,7));
W = squeeze(w(:,:,7));

t = 0:.01:10;
var1 = sin(2*pi*t);
var2 = atan(2*pi*t);
var3 = randn(1,length(t));

setappdata(hFig,'U',U);
setappdata(hFig,'V',V);
setappdata(hFig,'W',W);
setappdata(hFig,'var1',var1);
setappdata(hFig,'var2',var2);
setappdata(hFig,'var3',var3);


%Constructor
dd = dragndrop(hFig);

%Set
%Define draggable sources
set(dd,'DragHandles',[drag1 drag2]);

%Define drag targets
set(dd,'DropHandles',[drop1]);

%Define callbacks
set(dd,'DropCallbacks',@dd_example5_cbk);
