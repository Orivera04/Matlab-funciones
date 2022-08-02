%DD_EXAMPLE3       Drag and Drop Example 3: Dragging onto an axes
% This example shows how to create a drag and drop interface for
% interactive plotting.  

%% Create the figure
clear;close all
hFig = figure('Position',[200 300 500 400]);
frm = uicontrol('style','frame','pos',[15 235 90 140]);
strg = uicontrol('style','text','pos',[17 340 86 20],'String','Drag To Axis');
drag1 = uicontrol('Style','pushbutton','pos',[20 240 80 20],'String','surf');
drag2 = uicontrol('Style','pushbutton','pos',[20 265 80 20],'String','pcolor');
drag3 = uicontrol('Style','pushbutton','pos',[20 290 80 20],'String','mesh');
drag4 = uicontrol('Style','pushbutton','pos',[20 315 80 20],'String','contour');
drop1 = axes('Position',[.3 .11 .6 .8]);


%Constructor
dd = dragndrop(hFig);

%Set
%Define draggable sources
set(dd,'DragHandles',[drag1 drag2 drag3 drag4]);

%Define drag targets
set(dd,'DropHandles',[drop1]);

%Define callbacks
set(dd,'DropCallbacks',@dd_example3_cbk);
