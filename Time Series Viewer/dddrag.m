function dddrag
%dddrag     Implement the dragging functionality of dragndrop interface

source = gcbo;
hFig = get(source,'Parent');    %This restricts the application to uicontrols and axes
%Check the parent.  If it's an axes, not a figure, we do a little
%manipulation.  This allows you to drag an axes by grabbing one of it's
%lines.
if strcmp(get(hFig,'Type'),'axes')
    source = hFig;              %Assign the parent axes to source
    hFig = get(hFig,'Parent');
end;


%% Let user drag ...
%dragrect works with rect specified in pixels.  Odd, since it returns
%values in the host figure's units.
un = get(source ,'Units');
set(source,'Units','pixels');
rect = [get(source,'Position')];
finalrect = dragrect(rect);
set(source,'Units',un);

%For testing only - move the block to the drop location
%set(gcbo,'Position',finalrect(1,:));        %Main button

%% Figure out where we landed
current_object = hittest;   % Tells us what object we were over when letting go

%% Special case handling for current_object
% We get messed up if current_object is an axes child, since it won't be on
% the list of valid targets.  Replace current_object with the parent
if strcmp(get(get(current_object,'Parent'),'type'),'axes')
    current_object = get(current_object,'Parent');
end;

%% Get the dragndrop object from the figure
dd = getappdata(hFig,'dragndrop');          %Get object
Drops = get(dd,'DropHandles');              % Handles to drop targets

%% What did we hit?
hit_ind = find(current_object == Drops);    % Index into Drops of target we hit

%% Did we hit a drop target? If not, exit
if isempty(hit_ind)
    notvalid    % Indicate to user that this wasn't valid.
    return
end;

% Is our drop target valid for this source?
DropValidDrag = get(dd,'DropValidDrag');
validdrag = DropValidDrag{hit_ind};         % Valid drag sources for this target

if ~ismember(source,validdrag)
    notvalid
    return
end;

%Evaluate callback
DropCallbacks = get(dd,'DropCallbacks');
feval(DropCallbacks{hit_ind},source,Drops(hit_ind));


function notvalid
% Indicate to the user that the source can't be dropped here.
ptr = get(gcf,'Pointer');
P = no_icon;
set(gcf,'Pointer','custom');
set(gcf,'PointerShapeCData',P,'PointerShapeHotSpot',[9 9]);
pause(.2)
set(gcf,'Pointer',ptr);


function P = no_icon;
% Create icon for mouse pointer indicating target isn't valid
P=[ 2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
    2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
    2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
    2     2     2     2     2     2     2     1     1     2     2     2     1     2     2     2
    2     2     2     2     2     1     1     2     2     1     1     1     2     2     2     2
    2     2     2     2     1     2     2     2     2     2     1     1     2     2     2     2
    2     2     2     2     1     2     2     2     2     1     2     1     2     2     2     2
    2     2     2     1     2     2     2     2     1     2     2     2     1     2     2     2
    2     2     2     1     2     2     2     1     2     2     2     2     1     2     2     2
    2     2     2     2     1     2     1     2     2     2     2     1     2     2     2     2
    2     2     2     2     1     1     2     2     2     2     2     1     2     2     2     2
    2     2     2     2     1     1     1     2     2     1     1     2     2     2     2     2
    2     2     2     1     2     2     2     1     1     2     2     2     2     2     2     2
    2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
    2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2
    2     2     2     2     2     2     2     2     2     2     2     2     2     2     2     2];