%DD_EXAMPLE2       Drag and Drop Example 2: Multiple sources and targets.
% This example shows how to create a drag and drop interface containing
% multiple drag sources and drop targets.  It shows how to restrict which
% sources can be dropped on which targets.

%% Create the figure
clear;close all
hFig = figure;

%% Add the drag and drop components. 
% In this example, the user can drag one pushbutton and drop it on another
drag1 = uicontrol('Style','pushbutton', ...
    'pos',[160 200 160 20], ...
    'String','Drag Me Onto Drop1 or Drop2');
drag2 = uicontrol('Style','pushbutton', ...
    'pos',[160 160 160 20], ...
    'String','Drag Me Onto Drop1 Only');
drop1 = uicontrol('Style','pushbutton', ...
    'pos',[340 200 80 20], ...
    'String','Drop1');
drop2 = uicontrol('Style','pushbutton', ...
    'pos',[340 160 80 20], ...
    'String','Drop2');

%% Construct the Drag and Drop Object
% The drag and drop interface is handled through a dragndrop object.  This
% object is associated with a figure.  Multiple dragndrop objects can be
% associated with a single figure.
dd = dragndrop(hFig);

%% Configure the Drag and Drop Object
% The procedure for configuring a multiple source/target drag and drop
% interface is the same as for a single sources/single target.  We specify
% multiple handles as an array.

%%
% Define draggable sources.  The user will be able to drag the buttons
% drag1 and drag2
set(dd,'DragHandles',[drag1 drag2]);

%%
% Define drop targets.  The user will be able to drop onto drop1 and drop2.
set(dd,'DropHandles',[drop1 drop2]);

%%
% Restrict drag2 to only be dropped on drop1.  By default, all drag sources
% can be dropped on all drop targets.  By setting the DropValidDrag property, we can 
% explicitly state which sources can be dropped on which targets.
% DropValidDrag takes a 1 by N cell (N is the number of drop targets).
% Each cell contains an array of handles to the sources which can be
% dropped on a given target.  The first element of the cell array
% corresponds to the first target defined in the set to DropHandles.
% This line says that drag1 and drag2 can be dropped on drop1, but that
% only drag1 can be dropped on drop2.
set(dd,'DropValidDrag',{[drag1 drag2],drag1});


%%
% Define callbacks.  Note that this callback will not be evaluated if the
% user drops drag2 onto drop2, since this is not a valid combination.
set(dd,'DropCallbacks',@dd_example1_cbk);