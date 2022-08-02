%DD_EXAMPLE4       Drag and Drop Example 4: Multiple callback functions
% This example shows how to associate different callback functions with
% each drop target. 

%Drag and drop to create plots
%2 Axes: top is 2D, bottom is 3D
clear;close all
hFig = figure('Position',[200 300 500 400]);
frm = uicontrol('style','frame','pos',[15 235 90 140]);
strg = uicontrol('style','text','pos',[17 340 86 20],'String','Drag To Axis');
drag1 = uicontrol('Style','pushbutton','pos',[20 240 80 20],'String','peaks');
drag2 = uicontrol('Style','pushbutton','pos',[20 265 80 20],'String','membrane');
drop1 = axes('Position',[.3 .61 .6 .3]);
drop2 = axes('Position',[.3 .11 .6 .3]);
view(3)

%Constructor
dd = dragndrop(hFig);

%Define draggable sources
set(dd,'DragHandles',[drag1 drag2]);

%Define drag targets
set(dd,'DropHandles',[drop1 drop2]);

%Define callbacks
% We want different functionality depending on which axes the button is
% dropped onto.  Dropping on the top axes will create a 2D plot, while
% dropping on the bottom axes will create a 3D plot.  We set DropCallbacks
% to a cell array, with the elements of the cell corresponding to the drop
% targets set in DropHandles.
dd = set(dd,'DropCallbacks',{@dd_example4_cbk1,@dd_example4_cbk2});
