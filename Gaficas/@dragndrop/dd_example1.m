%DD_EXAMPLE1       Drag and Drop Example 1: An introduction.
% This example introduces the fundamental procedure for using the Drag and
% Drop interface.

%% Create the figure
clear;close all
x=0:0.1:3.14;
y=sin(x);
plot(x,y);
hFig = figure;

%% Add the drag and drop components. 
% In this example, the user can drag one pushbutton and drop it on another
drag1 = uicontrol('Style','pushbutton', ...
    'pos',[200 200 80 20], ...
    'String','Drag Me ...');
drop1 = uicontrol('Style','pushbutton', ...
    'pos',[300 200 80 20], ...
    'String',' ... Drop Here');

%% Construct the Drag and Drop Object
% The drag and drop interface is handled through a dragndrop object.  This
% object is associated with a figure.  
dd = dragndrop(hFig);

%% 
% Display summary for the Drag and Drop Object.  Typing the name of the
% object lists all of it's properties and their current values.
dd

%% Configure the Drag and Drop Object
% There are a minimum of three steps for configuring 
% the drag and drop interface.  All configuration is performed using the
% SET command.  The syntax is SET(dd,'Property','Value');
%
% * Define draggable sources.  
% * Define drop targets.  
% * Define the callbacks.  This defines what happens when a source is
% dropped onto a target.

%%
% Define draggable sources.  The user will be able to drag the button drag1
set(dd,'DragHandles',drag1);

%%
% Define drop targets.  The user will be able to drop drag1 onto drop1.
set(dd,'DropHandles',drop1);

%%
% Define callbacks.  When the user drops drag1 onto drop1, the code in
% DD_EXAMPLE_CBK will be evaluated.
set(dd,'DropCallbacks',@dd_example1_cbk);


 