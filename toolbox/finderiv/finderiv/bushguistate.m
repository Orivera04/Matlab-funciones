function AxesHandle = bushguistate(varargin)
% BUSHGUISTATE displays and selects states of a bushy tree
% Click on a circle to select the state.
% Right-click (Alt Click) on a circle to unselect
%
% AxesHandle = bushguistate(AxesHandle, NumBranch, NumLevels)
% AxesHandle = bushguistate(AxesHandle, NumChild)
% AxesHandle = bushguistate(AxesHandle, Tree)
% 
% AxesHandle - input may be omitted to create a new axes
% NumBranch  - (scalar) number of children at every level
% NumLevels  - (scalar) number of levels
% NumChild   - vector of children at each level
% Tree       - Bushy tree structure
% 
% getappdata(AxesHandle, Name) to access data on the gui or change behavior
% Name is one of:
%  'Selection' - cell array of BranchList containing selected nodes.
%  'HighlightMode' - {'path', 'state', 'node'}
%     'node'   - default, node with children
%     'state' - only selected node
%     'path'   - path to root
%  'ListMode' -{'list', 'replace'}
%     'list'   - default, maintain a selected list
%     'replace'- only allow one selection at a time
%  'SelectFunction'   - string to execute after selecting
%  'UnselectFunction' - string to execute after unselecting
%  

%-----------------------------------------------------------------
% Unimplemented features
%
% Scrolling the view
% Tweaking the Y positions
%-----------------------------------------------------------------

% JHA 9/21/98
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $  $Date: 2002/04/14 16:37:55 $

%-----------------------------------------------------------------
% Parse a callback
%-----------------------------------------------------------------
if ischar(varargin{1})
  ActionString = varargin{1};
else
  ActionString = 'init';
end

switch ActionString

  case 'stateclick'
    % recieved a click on a state
    bushguistateclick(gcbo);
    
  case 'init'
    % instantiate the gui for the first time
    AxesHandle = bushguistateinit(varargin{:});
    if nargout==0,
      clear('AxesHandle');
    end

  case 'clear'
    % clear all selections
    if nargin<2,
      AxesHandle = gca;
    else
      AxesHandle = varargin{2};
    end
    bushguistateclear(AxesHandle);
    
end

  
%-----------------------------------------------------------------
% subfunction bushguistateinit handles the command line call
%-----------------------------------------------------------------
function AxesHandle = bushguistateinit(varargin)

%-----------------------------------------------------------------
% Parse inputs
% AxesHandle      : Handle of axes for gui
% NumLevels       : Number of time levels in the displayed tree
% NumChild(Level) : Number of children at each layer of the tree
%-----------------------------------------------------------------
Args = varargin;

% check for a current AxesHandle as the first argument
if ( (length(Args{1})==1) & ishandle(Args{1}) & ...
      strcmp( get(Args{1},'Type') , 'axes' ) )
  % an axes handle is passed in
  AxesHandle = Args{1};
  Args(1) = [];
else
  AxesHandle = axes;
end

% Now parse information on the tree
if iscell(Args{1})
  % assume a tree is passed in
  Tree = Args{1};
  [NumLevels, NumChild] = bushshape(Tree);
elseif ( length(Args)==1 )
  % NumChild vector
  NumChild = Args{1};
  NumLevels = length(NumChild);
else
  % NumBranch, NumLevels scalars
  NumBranch = Args{1};
  NumLevels = Args{2};
  NumChild = NumBranch*ones(1,NumLevels);
  NumChild(end) = 0;
end

%-----------------------------------------------------------------
% Dimensions
% NumStates(Level) : Number of states at each layer of the tree
%-----------------------------------------------------------------
% Compute the number of states at each level
% Multiply by the number of branches at each stage
NumStates = ones(1,NumLevels);
NumStates(2:end) = NumChild(1:end-1);
NumStates = cumprod(NumStates);


%-----------------------------------------------------------------
% Selection registry
bushguistatereginit(AxesHandle, NumChild);

% Color Registry
[ColorLine, ColorState] = bushguistatecolinit(AxesHandle);

% Highlighting
bushguistatehighlightinit(AxesHandle);

% External Actions for bushguistateclick
if ~isappdata(AxesHandle,'SelectFunction')
  setappdata(AxesHandle, 'SelectFunction', '');
end
if ~isappdata(AxesHandle, 'UnselectFunction');
  setappdata(AxesHandle, 'UnselectFunction', '');
end
%-----------------------------------------------------------------
% Set axes limits
set(AxesHandle,'XLim',[0,NumLevels+1]);
set(AxesHandle,'YLim',[-0.1,1.1]);
set(AxesHandle,'Box','on');
set(AxesHandle,'XTick', bushguistatexpos((1:NumLevels)) );
set(AxesHandle,'YTick', [] );

%-----------------------------------------------------------------
% Plot lines and state markers
% StateHandle carries appdata:
%   'StateLoc'    - [Level, Loc] position in tree
%   'LineHandle'  - line headed toward root
%   'ChildStateHandles' - vector of State Handles of children
%-----------------------------------------------------------------

% Create the marker for the root state
StateHandle = line( ... 
    bushguistatexpos(1,1), ...
    bushguistateypos(1,1), ...
    'Color', ColorState, ...
    'Marker','o', ...
    'Tag','StateMark', ...
    'ButtonDownFcn','bushguistate(''stateclick'');');

setappdata(StateHandle, 'LineHandle', []);
setappdata(StateHandle, 'StateLoc', [1 1]);

% Make a list of Parent State Handles
ParentStateHandles = StateHandle;

for Level = 1:NumLevels-1,
  
  XParents = bushguistatexpos(Level  , NumStates);
  YParents = bushguistateypos(Level  , NumStates);

  XChilds  = bushguistatexpos(Level+1, NumStates);
  YChilds  = bushguistateypos(Level+1, NumStates);
  
  % Storage for all the children
  ChildStateHandles = zeros(NumStates(Level+1),1);
  ChildLineHandles  = zeros(NumStates(Level+1),1);
  
  % There are NumChild(Level) times as many children as parents
  NChild = NumChild(Level);
  
  % Create the line objects in batches
  for Child = 1:NChild
    
    % Create the connecting lines for one branch
    LineHandles = line( ...
        [XParents; XChilds(Child:NChild:end)], ...
        [YParents; YChilds(Child:NChild:end)], ...
        'Color', ColorLine, ...
        'HitTest', 'off');
    
    % Store the connecting lines
    ChildLineHandles(Child:NChild:end) = LineHandles;
    
  end
    
  % Create the child state objects
  for jChild = 1:NumStates(Level+1)
    
    % Create a child handle with a single point
    StateHandle = line( ...
        XChilds(jChild), ...
        YChilds(jChild), ...
        'Color', ColorState, ...
        'Marker','o', ...
        'Tag','StateMark', ...
        'ButtonDownFcn','bushguistate(''stateclick'');');
    
    % Store the states
    ChildStateHandles(jChild) = StateHandle;
  end
  
  % Set line properties  
  for jChild = 1:NumStates(Level+1)
    iParent = 1 + floor( (jChild-1)/NChild );
    
    % Associate a line with it's parent State
    setappdata(ChildLineHandles(jChild), ... 
        'StateHandle', ParentStateHandles(iParent));
  end
    
  % Set child handle properties
  for jChild = 1:NumStates(Level+1)
    
    % Have each marker remember it's state location
    setappdata(ChildStateHandles(jChild), 'StateLoc', [Level+1 jChild]);

    % Associate a state with it's rootward LineHandle
    setappdata(ChildStateHandles(jChild), ...
        'LineHandle', ChildLineHandles(jChild));
  end
  
  % Set Parent handle properites
  ChildStateList = reshape(ChildStateHandles, NChild, NumStates(Level));
  for iParent = 1:NumStates(Level)
    
    % Associate a state with its child states
    setappdata(ParentStateHandles(iParent), ...
        'ChildStateList', ChildStateList(:,iParent));
  end
    
  % Set up the next generation
  ParentStateHandles = ChildStateHandles;

end % loop over levels


%-----------------------------------------------------------------
% subfunction bushguistateclick handles the event state marker clicked
%-----------------------------------------------------------------
function bushguistateclick(StateHandle)

% Get locality information
AxesHandle = get(StateHandle,'Parent');
FigHandle = get(AxesHandle,'Parent');
ClickType = get(FigHandle,'SelectionType');

% Find Operation Modes
ListMode = getappdata(AxesHandle, 'ListMode');
SelectFunction = getappdata(AxesHandle, 'SelectFunction');
UnselectFunction = getappdata(AxesHandle, 'UnselectFunction');

% Get the location of the state marker
StateLoc = getappdata(StateHandle, 'StateLoc');

% Decide if this is a selection or an unselection
switch ClickType

  case {'normal', 'open'}
    % Record the selection if possible
    Selectable = bushguistateregister(AxesHandle, StateLoc, StateHandle);

    if Selectable
    
      % Highlight the selection
      bushguistatehighlight(AxesHandle, StateLoc, StateHandle);
      
      if (strcmp( ListMode, 'replace' ))
        % Trim the list to one entry
        LocSet    = getappdata(AxesHandle, 'LocSet');
        HandleSet = getappdata(AxesHandle, 'HandleSet');

        [OldLocSet, OLInd] = setdiff( LocSet, StateLoc, 'rows' );
        for k = 1:length(OLInd)
          bushguistateremove(AxesHandle, LocSet(OLInd(k),:));
          bushguistateunhighlight(AxesHandle, ...
              LocSet(OLInd(k),:), HandleSet(OLInd(k),:) );
        end
        
      end % replace code
      
    end % selectable
    
    % Execute external functions
    eval(SelectFunction);

  case 'alt'
    % Release the selection and it's color if it is registered
    Selectable = bushguistateremove(AxesHandle, StateLoc);

    if Selectable
      % Selected location was registered
      
      % UnHighlight the selection
      bushguistateunhighlight(AxesHandle, StateLoc, StateHandle);
      
    end

    % Execute external functions
    eval(UnselectFunction);
    
end
    
%-----------------------------------------------------------------
% clear all selections
function bushguistateclear(AxesHandle)
LocSet    = getappdata(AxesHandle, 'LocSet');
HandleSet = getappdata(AxesHandle, 'HandleSet');

for k = 1:length(HandleSet)
  bushguistateremove(AxesHandle, LocSet(k,:));
  bushguistateunhighlight(AxesHandle, ...
      LocSet(k,:), HandleSet(k,:) );
end

%-----------------------------------------------------------------
% Utilities
%-----------------------------------------------------------------
function YPos = bushguistateypos(Level, NStates)
dy = 1/(NStates(Level)+1);
YPos = 1 - dy*(1:NStates(Level));

%-----------------------------------------------------------------
function XPos = bushguistatexpos(Level, NStates)
if nargin<2, 
  NStates = 1;
end
XPos = Level*ones(1,NStates(Level(1)));

%-----------------------------------------------------------------
% Selection registry
% LocSet   [NSelected by 2] : List of selected state marker locations
% ColorSet [NSelected by 3] : List of colors of selected markers
% Select cell(NSelected by 1) : List of selected BranchLists
%
% Functions 
% bushguistatereginit(AxesHandle)
% SelectFlag = bushguistateregister(AxesHandle, StateLoc, StateHandle)
% SelectFlag = bushguistateremove(AxesHandle, StateLoc)
% Color      = bushguistatecolor(AxesHandle, StateLoc)
% bushguistatehighlightset(AxesHandle)
%-----------------------------------------------------------------
function bushguistatereginit(AxesHandle, NumChild)
setappdata(AxesHandle, 'NumChild',  NumChild);
setappdata(AxesHandle, 'LocSet',    zeros(0,2) );
setappdata(AxesHandle, 'Selection', cell(0,1)  );
setappdata(AxesHandle, 'ColorSet',  zeros(0,3) );
setappdata(AxesHandle, 'HandleSet', zeros(0,1) );
if ~isappdata(AxesHandle, 'ListMode')
  setappdata(AxesHandle, 'ListMode', 'replace');
end

%-----------------------------------------------------------------
function [Selectable, SelectFlag] = bushguistateregister(AxesHandle, StateLoc, StateHandle)
NumChild  = getappdata(AxesHandle, 'NumChild');
LocSet    = getappdata(AxesHandle, 'LocSet');
Selection = getappdata(AxesHandle, 'Selection');
ColorSet  = getappdata(AxesHandle, 'ColorSet');
HandleSet = getappdata(AxesHandle, 'HandleSet');

if nargin<3,
  StateHandle = NaN;
end

% Make anything selectable for now
Selectable = 1;

% Toggle the color
ColorSelect = bushguistatenextcol(AxesHandle);

% Check if StateLoc is already registered
[Key, LocInd] = intersect(LocSet, StateLoc, 'rows');
SelectFlag = ~isempty(LocInd);

if SelectFlag % Location is already selected
  
  % Just register the new color
  ColorSet(LocInd,:) = ColorSelect;

else % Need to add location

  % Compute BranchList for the state
  BranchList = bushloc2branch(NumChild, StateLoc(1), StateLoc(2));
  
  % Add to lists
  LocSet = [LocSet; StateLoc];
  Selection = [Selection; {BranchList}];
  ColorSet = [ColorSet; ColorSelect];
  HandleSet = [HandleSet; StateHandle];
end

% Save data back
setappdata(AxesHandle, 'LocSet'   , LocSet);
setappdata(AxesHandle, 'Selection', Selection);
setappdata(AxesHandle, 'ColorSet' , ColorSet);
setappdata(AxesHandle, 'HandleSet', HandleSet);
  
%-----------------------------------------------------------------
% SelectFlag is 1 if StateLoc is selected, 0 otherwise
function SelectFlag = bushguistateremove(AxesHandle, StateLoc)
LocSet    = getappdata(AxesHandle, 'LocSet');
Selection = getappdata(AxesHandle, 'Selection');
ColorSet  = getappdata(AxesHandle, 'ColorSet');
HandleSet = getappdata(AxesHandle, 'HandleSet');

% Check if StateLoc is already registered
[Key, LocInd] = intersect(LocSet, StateLoc, 'rows');
SelectFlag = ~isempty(LocInd);

if SelectFlag % Location is already selected
  
  % Remove selection from lists
  LocSet(LocInd,:) = [];
  Selection(LocInd,:) = [];
  ColorSet(LocInd,:) = [];
  HandleSet(LocInd,:) = [];
  
end

% Save data back
setappdata(AxesHandle, 'LocSet'   , LocSet);
setappdata(AxesHandle, 'Selection', Selection);
setappdata(AxesHandle, 'ColorSet' , ColorSet);
setappdata(AxesHandle, 'HandleSet', HandleSet);

%-----------------------------------------------------------------
function [ColorLine, ColorState] = bushguistatecolor(AxesHandle, StateLoc)
LocSet    = getappdata(AxesHandle, 'LocSet');
ColorSet  = getappdata(AxesHandle, 'ColorSet');

% Check if StateLoc is already registered
[Key, LocInd] = intersect(LocSet, StateLoc, 'rows');
SelectFlag = ~isempty(LocInd);

if SelectFlag
  ColorLine = ColorSet(LocInd,:);
  ColorState = ColorLine;
else
  [ColorLine, ColorState] = bushguistatedefcol(AxesHandle);
end
  
%-----------------------------------------------------------------
function bushguistatehighlightset(AxesHandle)
LocSet    = getappdata(AxesHandle, 'LocSet');
HandleSet = getappdata(AxesHandle, 'HandleSet');

for k = 1:length(HandleSet)
  bushguistatehighlight(AxesHandle, LocSet(k,:), HandleSet(k));
end
  
%-----------------------------------------------------------------
% Selection Highlighting
%
% Functions:
% bushguistatehighlightinit(AxesHandle)
% bushguistatehighlight(AxesHandle, StateLoc, StateHandle)
% bushguistateunhighlight(AxesHandle, StateLoc, StateHandle)
%-----------------------------------------------------------------
function bushguistatehighlightinit(AxesHandle)
if ~isappdata(AxesHandle, 'HighlightMode')
  setappdata(AxesHandle, 'HighlightMode','node')
end

%-----------------------------------------------------------------
function bushguistatehighlight(AxesHandle, StateLoc, StateHandle)
HighlightMode = getappdata(AxesHandle, 'HighlightMode');

% Get highlighting color
ColorSelect = bushguistatecolor(AxesHandle, StateLoc);

switch HighlightMode
  case 'path'
    set(StateHandle,'MarkerEdgeColor',ColorSelect);
    set(StateHandle,'MarkerFaceColor',ColorSelect);
    bushguistatehighlightpath(StateHandle, ColorSelect);
    
  case 'state'
    set(StateHandle,'MarkerEdgeColor',ColorSelect);
    set(StateHandle,'MarkerFaceColor',ColorSelect);
    
  case 'node'
    set(StateHandle,'MarkerEdgeColor',ColorSelect);
    set(StateHandle,'MarkerFaceColor',ColorSelect);
    ChildStates = getappdata(StateHandle, 'ChildStateList');
    for jChild = 1:length(ChildStates)
      set(ChildStates(jChild), 'MarkerEdgeColor', ColorSelect);
      LineHandle = getappdata(ChildStates(jChild),'LineHandle');
      set(LineHandle, 'Color', ColorSelect');
    end

end


%-----------------------------------------------------------------
function bushguistateunhighlight(AxesHandle, StateLoc, StateHandle)
HighlightMode = getappdata(AxesHandle, 'HighlightMode');

% Get basic color
[ColorLine, ColorState] = bushguistatecolor(AxesHandle, StateLoc);

switch HighlightMode
  case 'path'
    set(StateHandle,'MarkerEdgeColor',ColorState);
    set(StateHandle,'MarkerFaceColor','none');
    bushguistatehighlightpath(StateHandle, ColorLine);

    % Re-highlight paths in the selected set
    bushguistatehighlightset(AxesHandle);
    
  case 'state'
    set(StateHandle,'MarkerEdgeColor',ColorState);
    set(StateHandle,'MarkerFaceColor','none');
    
  case 'node'
    set(StateHandle,'MarkerEdgeColor',ColorState);
    set(StateHandle,'MarkerFaceColor','none');
    ChildStates = getappdata(StateHandle, 'ChildStateList');
    for jChild = 1:length(ChildStates)
      set(ChildStates(jChild), 'MarkerEdgeColor', ColorState);
      LineHandle = getappdata(ChildStates(jChild),'LineHandle');
      set(LineHandle, 'Color', ColorLine');
    end
    
    % Re-highlight nodes in the selected set
    bushguistatehighlightset(AxesHandle);
    
end

%-----------------------------------------------------------------
function bushguistatehighlightpath(StateHandle, ColorSelect)
LineHandle = getappdata(StateHandle,'LineHandle');
while ~isempty(LineHandle)
  set(LineHandle, 'color', ColorSelect);
  StateParent = getappdata(LineHandle, 'StateHandle');
  LineHandle = getappdata(StateParent,'LineHandle');
end

%-----------------------------------------------------------------
% Color Registry
%
% Functions:
% [ColorLine, ColorState] = bushguistatecolinit(AxesHandle)
% [ColorLine, ColorState] = bushguistatedefcol(AxesHandle)
% ColorSelect = bushguistatenextcol(AxesHandle)
%-----------------------------------------------------------------
function [ColorLine, ColorState] = bushguistatecolinit(AxesHandle)
ColorOrder = get(AxesHandle, 'ColorOrder');
ColorState = ColorOrder(1,:); % Color of state markers
ColorLine = ColorOrder(2,:);  % Color of unselected lines connecting states
ColorSelectOrder = ColorOrder(3:end,:); % Colors available for selection
ColorSelectInd = 1; % Location of next color in ColorSelectOrder

setappdata(AxesHandle, 'ColorState', ColorState);
setappdata(AxesHandle, 'ColorLine',  ColorLine);
setappdata(AxesHandle, 'ColorSelectOrder', ColorSelectOrder);
setappdata(AxesHandle, 'ColorSelectInd',   ColorSelectInd);

%-----------------------------------------------------------------
function ColorSelect = bushguistatenextcol(AxesHandle)
ColorSelectOrder = getappdata(AxesHandle, 'ColorSelectOrder');
ColorSelectInd   = getappdata(AxesHandle, 'ColorSelectInd');

ColorSelect = ColorSelectOrder(ColorSelectInd,:);
ColorSelectInd = 1 + mod(ColorSelectInd, size(ColorSelectOrder,1));
setappdata(AxesHandle, 'ColorSelectInd', ColorSelectInd);

%-----------------------------------------------------------------
function [ColorLine, ColorState] = bushguistatedefcol(AxesHandle)
ColorState       = getappdata(AxesHandle, 'ColorState');
ColorLine        = getappdata(AxesHandle, 'ColorLine');

function nono
      % Associate the line with it's parent
      setappdata(LineHandles(iMark), ... 
          'StateHandle', ParentStateHandles(iMark));
