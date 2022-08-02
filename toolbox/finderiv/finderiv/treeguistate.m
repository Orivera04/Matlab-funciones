function AxesHandle = treeguistate(varargin)
% TREEGUISTATE Displays and selects states of a recombining tree.
% Click on a circle to select the state.
%
% AxesHandle = treeguistate(AxesHandle, NumLevels)
% AxesHandle = treeguistate(AxesHandle, Tree)
% 
% Inputs:
%    AxesHandle - Input may be omitted to create a new axes
%    NumLevels  - Number of levels(scalar)
%    Tree       - Tree structure
% 
% getappdata(AxesHandle, Name) to access data on the gui or change behavior
% Name is one of:
%  'Selection'     - cell array of BranchList containing selected nodes.
%  'HighlightMode' - {'path', 'state', 'node'}
%  'node'          - default, node with children
%  'state'         - only selected node
%  'ListMode'      -{'list', 'replace'}
%  'list'          - default, maintain a selected list
%  'replace'       - only allow one selection at a time
%  'SelectFunction'   - string to execute after selecting
%  'UnselectFunction' - string to execute after unselecting
%  

%   Author(s): M. Reyes-Kattar 4-May-2001
%   Copyright 1998-2002 The MathWorks, Inc.
%   $Revision: 1.2 $  $                 $

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
	AxesHandle = gca;
	try
		treeguistateclick(gcbo);
	catch
		errmsg = lasterr;

		% Eat OK error message
		if isempty(findstr(errmsg, 'INVAL_PARENT'))
			error(errmsg)
		else
			AxesHandle = -1;
		end
	end
	
case 'init'
	% instantiate the gui for the first time
	AxesHandle = treeguistateinit(varargin{:});
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
	treeguistateclear(AxesHandle);
	
end


%-----------------------------------------------------------------
% subfunction treeguistateinit handles the command line call
%-----------------------------------------------------------------
function AxesHandle = treeguistateinit(varargin)

%-----------------------------------------------------------------
% Parse inputs
% AxesHandle      : Handle of axes for gui
% NumLevels       : Number of time levels in the displayed tree
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
	[NumLevels, NumPos, IsPriceTree] = treeshape(Tree);
	NumChild = 2;
elseif ( length(Args)==1 )
	% NumChild vector
	NumChild = 2;
	NumLevels = Args{1};
end

%-----------------------------------------------------------------
% Dimensions
% NumStates(Level) : Number of states at each layer of the tree
%-----------------------------------------------------------------
% Compute the number of states at each level
% Multiply by the number of branches at each stage
if(IsPriceTree)
	NumStates = [1:NumLevels-1 NumLevels-1];
else
	NumStates = [1:NumLevels];
end

%-----------------------------------------------------------------
% Selection registry
treeguistatereginit(AxesHandle, NumLevels);

% Color Registry
[ColorLine, ColorState] = treeguistatecolinit(AxesHandle);

% Highlighting
treeguistatehighlightinit(AxesHandle);

% External Actions for treeguistateclick
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
set(AxesHandle,'XTick', treeguistatexpos((1:NumLevels)) );
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
	treeguistatexpos(1,1), ...
	treeguistateypos(1,1), ...
	'Color', ColorState, ...
	'Marker','o', ...
	'Tag','StateMark', ...
	'ButtonDownFcn','treeguistate(''stateclick'');');

setappdata(StateHandle, 'LineHandle', []);
setappdata(StateHandle, 'StateLoc', [1 1]);

% Make a list of Parent State Handles
ParentStateHandles = StateHandle;
NChild = 2;
if(IsPriceTree)
	LastLevel = NumLevels-2;
else
	LastLevel = NumLevels-1;
end

for Level = 1:LastLevel,
	
	XParents = treeguistatexpos(Level  , NumStates);
	YParents = treeguistateypos(Level  , NumStates);
	
	XChilds  = treeguistatexpos(Level+1, NumStates);
	YChilds  = treeguistateypos(Level+1, NumStates);
	
	% Storage for all the children
	ChildStateHandles = zeros(NumStates(Level),1);
	ChildLineHandles  = zeros(2 * NumStates(Level),1);
	
	
	% Create the line objects in batches    
	% Branches going up
	ChildLineHandles(1:2:end-1) = line( ...
		[XParents; XChilds(1:end-1)], ...
		[YParents; YChilds(1:end-1)], ...
		'Color', ColorLine, ...
		'HitTest', 'off');
	
	% Branches going down
	ChildLineHandles(2:2:end) = line( ...
		[XParents; XChilds(2:end)], ...
		[YParents; YChilds(2:end)], ...
		'Color', ColorLine, ...
		'HitTest', 'off');    
	
	% Create the child state objects
	for jChild = 1:NumStates(Level+1)
		
		% Create a child handle with a single point
		StateHandle = line( ...
			XChilds(jChild), ...
			YChilds(jChild), ...
			'Color', ColorState, ...
			'Marker','o', ...
			'Tag','StateMark', ...
			'ButtonDownFcn','treeguistate(''stateclick'');');
		
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
	end
	
	for iParent = 1:NumStates(Level)
		% Associate a state with it's children LineHandles
		setappdata(ParentStateHandles(iParent), ...
			'LineHandle', ChildLineHandles(2*iParent-1:2*iParent));
	end
	
	
	% Set Parent handle properites
	% Parents share middle states
	UniqueChildStateHandles = ChildStateHandles;
	if(length(ChildStateHandles)>2)
		MidStates = ones(NChild,1) * ChildStateHandles(2:end-1)';
		ChildStateHandles = [ChildStateHandles(1); MidStates(:); ChildStateHandles(end)];
	end
	ChildStateList = reshape(ChildStateHandles, NChild, NumStates(Level));
	for iParent = 1:NumStates(Level)
		
		% Associate a state with its child states
		setappdata(ParentStateHandles(iParent), ...
			'ChildStateList', ChildStateList(:,iParent));
		
		% Associate each child state with its parent state
		for iChild=iParent:iParent+1
			Parents = getappdata(UniqueChildStateHandles(iChild), 'ParentStateList');
			Parents = [Parents;ParentStateHandles(iParent)];
			setappdata(UniqueChildStateHandles(iChild), 'ParentStateList', Parents);
		end
	end
	
	% Set up the next generation
	ParentStateHandles = UniqueChildStateHandles;
	
end % loop over levels

% If it's a price tree, we're still missing a level
if(IsPriceTree)
	XParents = treeguistatexpos(NumLevels-1  , NumStates);
	YParents = treeguistateypos(NumLevels-1  , NumStates);
	
	XChilds  = treeguistatexpos(NumLevels, NumStates);
	YChilds  = treeguistateypos(NumLevels, NumStates);
	
	ChildLineHandles = zeros(NumStates(NumLevels-1),1);
	ChildStateHandles= zeros(NumStates(NumLevels-1),1);
	
	% Create the line objects in batch    
	ChildLineHandles(:) = line( ...
		[XParents; XChilds], ...
		[YParents; YChilds], ...
		'Color', ColorLine, ...
		'HitTest', 'off');
	
	% Create a child handle with a single point
	for iMarker=1:length(XChilds)
		ChildStateHandles(iMarker) = line( ...
			XChilds(iMarker), ...
			YChilds(iMarker), ...
			'Color', ColorState, ...
			'Marker','o', ...
			'Tag','StateMark', ...
			'ButtonDownFcn','treeguistate(''stateclick'');');		
	end
	
		% Set line properties  
	for jChild = 1:NumStates(end)		
		% Associate a line with it's parent State
		setappdata(ChildLineHandles(jChild), ... 
			'StateHandle', ParentStateHandles(jChild));
	end
	
	% Set child handle properties
	for jChild = 1:NumStates(end)
		% Have each marker remember it's state location
		setappdata(ChildStateHandles(jChild), 'StateLoc', [length(NumStates) jChild]);    
	end
	
	for iParent = 1:NumStates(end)
		% Associate a state with it's children LineHandles
		setappdata(ParentStateHandles(iParent), ...
			'LineHandle', ChildLineHandles(iParent));
	end
	
	for iParent = 1:NumStates(end)
		% Associate each parent with it's child state
		setappdata(ParentStateHandles(iParent), ...
			'ChildStateList', ChildStateHandles(iParent));
	end
	
	for iChild = 1:NumStates(end)
		% Associate each child with it's parent state
		setappdata(ChildStateHandles(iChild), ...
			'ParentStateList', ParentStateHandles(iChild));
	end

end

%-----------------------------------------------------------------
% subfunction treeguistateclick handles the event state marker clicked
%-----------------------------------------------------------------
function treeguistateclick(StateHandle)

% Get locality information
AxesHandle = get(StateHandle,'Parent');
FigHandle = get(AxesHandle,'Parent');
ClickType = get(FigHandle,'SelectionType');

% Find Operation Modes
ListMode = getappdata(AxesHandle, 'ListMode');
SelectFunction = getappdata(AxesHandle, 'SelectFunction');
UnselectFunction = getappdata(AxesHandle, 'UnselectFunction');
HighlightMode = getappdata(AxesHandle, 'HighlightMode');

% Get the location of the state marker
StateLoc = getappdata(StateHandle, 'StateLoc');

% Decide if this is a selection or an unselection
switch ClickType
	
case {'normal', 'open'}
	% Record the selection if possible
	[Selectable, SelectFlag, NewPath] = treeguistateregister(AxesHandle, StateLoc, StateHandle);
	
	if Selectable
		
		% Highlight the selection
		HandleSet = getappdata(AxesHandle, 'HandleSet');				
		
		if (strcmp( ListMode, 'replace' ))
			% Get rid of everything that was selected/highlighted
			
			% Trim the list to one entry
			LocSet    = getappdata(AxesHandle, 'LocSet');
			HandleSet = getappdata(AxesHandle, 'HandleSet');
			
			% Remove old selected states
			treeguistateremove(AxesHandle, 1:(length(LocSet)-1));
			
			% Find the states that are not highlighted
			CurrLocSet = [];
			for SelIdx = 1:length(LocSet)
				CurrLocSet = [CurrLocSet; LocSet{SelIdx}(end,:)];
			end
			
			[OldLocSet, OLInd] = setdiff( CurrLocSet, StateLoc, 'rows' );
			for k = 1:length(OLInd)
				treeguistateunhighlight(AxesHandle, ...
					LocSet{OLInd(k)}, HandleSet{OLInd(k)} );
			end			
			
		end % replace code
		
		% This must be done after calling unhighlight because two nodes
		% may be sharing a child, and unhighlighting after highlighting
		% in the case of 'node and children' will leave the shared child
		% unhighlighted.
		treeguistatehighlight(AxesHandle, StateLoc, HandleSet{end});
		
	end % selectable
	
	% Execute external functions
	eval(SelectFunction);
	
case 'alt'
	% Release the selection and it's color if it is registered
	Selectable = treeguistateremove(AxesHandle, StateLoc);
	
	if Selectable
		% Selected location was registered
		
		% UnHighlight the selection
		treeguistateunhighlight(AxesHandle, StateLoc, StateHandle);
		
	end
	
	% Execute external functions
	eval(UnselectFunction);
	
end

%-----------------------------------------------------------------
% clear all selections
function treeguistateclear(AxesHandle)
LocSet    = getappdata(AxesHandle, 'LocSet');
HandleSet = getappdata(AxesHandle, 'HandleSet');

treeguistateremove(AxesHandle, 1:length(HandleSet));

for k = 1:length(HandleSet)
	treeguistateunhighlight(AxesHandle, ...
		LocSet{k}, HandleSet{k} );
end

treeguistatereginit(AxesHandle, length(HandleSet));

%-----------------------------------------------------------------
% Utilities
%-----------------------------------------------------------------
function YPos = treeguistateypos(Level, NStates)
dy = 1/(NStates(Level)+1);
YPos = 1 - dy*(1:NStates(Level));

%-----------------------------------------------------------------
function XPos = treeguistatexpos(Level, NStates)
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
% treeguistatereginit(AxesHandle)
% SelectFlag = treeguistateregister(AxesHandle, StateLoc, StateHandle)
% SelectFlag = treeguistateremove(AxesHandle, StateLoc)
% Color      = treeguistatecolor(AxesHandle, StateLoc)
% treeguistatehighlightset(AxesHandle)
%-----------------------------------------------------------------
function treeguistatereginit(AxesHandle, NumLevels)
setappdata(AxesHandle, 'NumLevels',  NumLevels);
setappdata(AxesHandle, 'LocSet',    cell(0,1) );
setappdata(AxesHandle, 'Selection', cell(0,1)  );
setappdata(AxesHandle, 'ColorSet',  zeros(0,3) );
setappdata(AxesHandle, 'HandleSet', cell(0,1) );
if ~isappdata(AxesHandle, 'ListMode')
	setappdata(AxesHandle, 'ListMode', 'replace');
end

%-----------------------------------------------------------------
function [Selectable, SelectFlag, NewPath] = treeguistateregister(AxesHandle, StateLoc, StateHandle)
NumChild  = 2;

ColorSet  = getappdata(AxesHandle, 'ColorSet');
ListMode  = getappdata(AxesHandle, 'ListMode');
LocSet    = getappdata(AxesHandle, 'LocSet');
Selection = getappdata(AxesHandle, 'Selection');
HandleSet = getappdata(AxesHandle, 'HandleSet');
CurrIdx = length(LocSet);
if isempty(LocSet) %nothing has ever been selected
	CurrLocSet = zeros(0,2);
	CurrSelection = [];
	CurrHandleSet = [];
else
	CurrLocSet = LocSet{end};
	CurrSelection = Selection{end};
	CurrHandleSet = HandleSet{end};
end

if nargin<3,
	StateHandle = NaN;
end

% Make anything selectable for now
Selectable = 1;

% Assume new path
NewPath = 1;

% Toggle the color
ColorSelect = treeguistatenextcol(AxesHandle);

% Check if StateLoc is already registered. Registered locations are at
% the end of each of the registered paths:
RegLocSet = [];
for iLoc = 1:length(LocSet)
	RegLocSet = [RegLocSet; LocSet{iLoc}(end,:)];
end

[Key, LocInd] = intersect(RegLocSet, StateLoc, 'rows');
SelectFlag = ~isempty(LocInd);

if SelectFlag % Location is already selected
	
	% Just register the new color
	ColorSet(LocInd,:) = ColorSelect;
	
else % Need to add location
	
	% Find the root node and build potential selection	
	SLoc = getappdata(StateHandle, 'StateLoc');
	Sel = [];
	HandlePath = [StateHandle];

	RootNodeHandle = StateHandle;
	PrevNodeHandle = getappdata(RootNodeHandle, 'ParentStateList');
	StateParents = PrevNodeHandle; %Hold parents of this node
	while(~isempty(PrevNodeHandle))		
		% Calculate current level's selection and hold it
		ParentSLoc = getappdata(PrevNodeHandle(1), 'StateLoc');
		SLoc = [ParentSLoc; SLoc];
		
		% Keep working its way to root node
		RootNodeHandle = PrevNodeHandle(1);
		HandlePath = [PrevNodeHandle(1); HandlePath];
		
		PrevNodeHandle = getappdata(RootNodeHandle, 'ParentStateList');
	end	

	% First node is always zero (no selection to get to root node)
	Sel = [0; diff(SLoc(:,2))+1];	
	
	% If HighlightMode is 'path', the selected node should
	% be one of the following:
	% a) Root node
	% b) Node on the first level
	% c) Child of the previously selected node
	if strcmp('path', getappdata(AxesHandle, 'HighlightMode'))
		
		if(StateHandle == RootNodeHandle)
			% New path will contain only the root
			SLoc = ones(1,2);
			HandlePath = [RootNodeHandle];
			Sel = [0];
		elseif(any(StateHandle == getappdata(RootNodeHandle, 'ChildStateList')))
			% New path will contain the root plus this node
			SLoc = [1, 1; getappdata(StateHandle, 'StateLoc')];
			HandlePath = [RootNodeHandle; StateHandle];
			Sel = [0; StateLoc(2)];
		elseif(isempty(HandleSet)) |(~any(StateParents == HandleSet{end}(end)))
	  		uiwait(errordlg('Parent of selected node must be selected', ...
				'Path Selection Error', 'modal'));
			
			% Restore previous color
			treeguistaterestoreprevcol(AxesHandle);
			error('INVAL_PARENT')			
			Selectable = 0; SelectFlag = [];
		else
			NewPath = 0;
						
			% Did we go up or down from the previous node?
			if(StateLoc(2)==1)
				% We're along the top path
				NewSel = 1;
			elseif(StateLoc(2)==StateLoc(1) )
				% We're along the bottom path
				NewSel = 2;
			elseif length(StateParents)==1
				% If neither of the above, and have a single
				% parent, then only one option (i.e. price 
				% tree last node)
				NewSel = 1;
			else
				% Anywhere in between
				PrevStateHandle = CurrHandleSet(end);
				NewSel = 2-(find(PrevStateHandle==StateParents) -1);
			end
		end		
	end
	
	if(Selectable)		
		
		% Add to lists
		if(NewPath==1) % either new path, or 'node' or 'state'
			LocSet{CurrIdx+1} = [SLoc];
			Selection{CurrIdx+1} = [Sel];
			ColorSet = [ColorSet; ColorSelect];
			HandleSet{CurrIdx+1} = [HandlePath];						
		else
			LocSet{CurrIdx} = [CurrLocSet; StateLoc];
			Selection{CurrIdx} = [CurrSelection; NewSel];
			ColorSet = [ColorSet; ColorSelect];
			HandleSet{CurrIdx} = [CurrHandleSet; StateHandle];
		end
	end
end

% Save data back
setappdata(AxesHandle, 'LocSet'   , LocSet);
setappdata(AxesHandle, 'Selection', Selection);
setappdata(AxesHandle, 'ColorSet' , ColorSet);
setappdata(AxesHandle, 'HandleSet', HandleSet);
setappdata(AxesHandle, 'NewPath', NewPath);


%-----------------------------------------------------------------
% SelectFlag is 1 if StateLoc is selected, 0 otherwise
function SelectFlag = treeguistateremove(AxesHandle, StateIdx)

if isempty(StateIdx)
	SelectFlag = 0;
	return;
end

LocSet    = getappdata(AxesHandle, 'LocSet');
Selection = getappdata(AxesHandle, 'Selection');
ColorSet  = getappdata(AxesHandle, 'ColorSet');
HandleSet = getappdata(AxesHandle, 'HandleSet');

% Get rid of selected states
LocSet(StateIdx) = [];
EmptyMask = cellfun('isempty', LocSet);
LocSet = LocSet(~EmptyMask);

Selection(StateIdx) = [];
EmptyMask = cellfun('isempty', Selection);
Selection = Selection(~EmptyMask);

HandleSet(StateIdx) = [];
EmptyMask = cellfun('isempty', HandleSet);
HandleSet = HandleSet(~EmptyMask);

ColorSet(StateIdx,:) = [];

% Save data back
setappdata(AxesHandle, 'LocSet'   , LocSet);
setappdata(AxesHandle, 'Selection', Selection);
setappdata(AxesHandle, 'ColorSet' , ColorSet);
setappdata(AxesHandle, 'HandleSet', HandleSet);

%-----------------------------------------------------------------
function [ColorLine, ColorState] = treeguistatecolor(AxesHandle, StateLoc)
LocSet    = getappdata(AxesHandle, 'LocSet');

% The selected states are at the end of each one of the paths contained
% in LocSet
CurrLocSet = [];
for iLoc=1:length(LocSet)	
	CurrLocSet = [CurrLocSet; LocSet{iLoc}(end,:)];
end

ColorSet  = getappdata(AxesHandle, 'ColorSet');

% Check if StateLoc is already registered
[Key, LocInd] = intersect(CurrLocSet, StateLoc, 'rows');
SelectFlag = ~isempty(LocInd);

if SelectFlag
	ColorLine = ColorSet(LocInd,:);
	ColorState = ColorLine;
else
	[ColorLine, ColorState] = treeguistatedefcol(AxesHandle);
end

%-----------------------------------------------------------------
function treeguistatehighlightset(AxesHandle)
LocSet    = getappdata(AxesHandle, 'LocSet');
HandleSet = getappdata(AxesHandle, 'HandleSet');

for k = 1:length(HandleSet)
	treeguistatehighlight(AxesHandle, LocSet{k}, HandleSet{k});
end

%-----------------------------------------------------------------
% Selection Highlighting
%
% Functions:
% treeguistatehighlightinit(AxesHandle)
% treeguistatehighlight(AxesHandle, StateLoc, StateHandle)
% treeguistateunhighlight(AxesHandle, StateLoc, StateHandle)
%-----------------------------------------------------------------
function treeguistatehighlightinit(AxesHandle)
if ~isappdata(AxesHandle, 'HighlightMode')
	setappdata(AxesHandle, 'HighlightMode','state')
end

%-----------------------------------------------------------------
function treeguistatehighlight(AxesHandle, StateLoc, StateHandle)
HighlightMode = getappdata(AxesHandle, 'HighlightMode');

% Get highlighting color
ColorSelect = treeguistatecolor(AxesHandle, StateLoc);

switch HighlightMode
case 'path'
	
	% If there was a previous node in this path, unselect it so
	% that only the last one is selected.
	if(length(StateHandle)>1)
		[ColorLine, ColorState] = treeguistatedefcol(AxesHandle);
		set(StateHandle(end-1),'MarkerEdgeColor',ColorState);
		set(StateHandle(end-1),'MarkerFaceColor','none');		
	end
	
	set(StateHandle(end),'MarkerEdgeColor',ColorSelect);
	set(StateHandle(end),'MarkerFaceColor',ColorSelect);
	treeguistatehighlightpath(StateHandle, ColorSelect);
	
case 'state'
	set(StateHandle(end),'MarkerEdgeColor',ColorSelect);
	set(StateHandle(end),'MarkerFaceColor',ColorSelect);
	
case 'node'
	set(StateHandle(end),'MarkerEdgeColor',ColorSelect);
	set(StateHandle(end),'MarkerFaceColor',ColorSelect);
	LineHandles = getappdata(StateHandle(end),'LineHandle');
	set(LineHandles, 'Color', ColorSelect');
	ChildStates = getappdata(StateHandle(end), 'ChildStateList');	
	for jChild = 1:length(ChildStates)
		set(ChildStates(jChild), 'MarkerEdgeColor', ColorSelect);      
	end
	
end


%-----------------------------------------------------------------
function treeguistateunhighlight(AxesHandle, StateLoc, StateHandle)
HighlightMode = getappdata(AxesHandle, 'HighlightMode');

% Get basic color
[ColorLine, ColorState] = treeguistatecolor(AxesHandle, StateLoc(end,:));

switch HighlightMode
case 'path'
	set(StateHandle(end),'MarkerEdgeColor',ColorState);
	set(StateHandle(end),'MarkerFaceColor','none');
	treeguistatehighlightpath(StateHandle, ColorLine);
		
case 'state'
	set(StateHandle(end),'MarkerEdgeColor',ColorState);
	set(StateHandle(end),'MarkerFaceColor','none');
	
case 'node'
	set(StateHandle(end),'MarkerEdgeColor',ColorState);
	set(StateHandle(end),'MarkerFaceColor','none');
	ChildStates = getappdata(StateHandle(end), 'ChildStateList');
	LineHandles = getappdata(StateHandle(end),'LineHandle');
	set(LineHandles, 'Color', ColorLine');
	for jChild = 1:length(ChildStates)
		set(ChildStates(jChild), 'MarkerEdgeColor', ColorState);
	end
		
end

%-----------------------------------------------------------------
function treeguistatehighlightpath(StateHandle, ColorSelect)

% Get current selection path
StateHandleSet = StateHandle;

% Walk the tree highlighting the branches
for iNode=1:length(StateHandleSet)-1;
	ChildNodeHandles = getappdata(StateHandleSet(iNode), 'ChildStateList');
	LineHandles = getappdata(StateHandleSet(iNode), 'LineHandle');
	set(LineHandles(find(StateHandleSet(iNode+1)==ChildNodeHandles)), 'color', ColorSelect);
end

%-----------------------------------------------------------------
% Color Registry
%
% Functions:
% [ColorLine, ColorState] = treeguistatecolinit(AxesHandle)
% [ColorLine, ColorState] = treeguistatedefcol(AxesHandle)
% ColorSelect = treeguistatenextcol(AxesHandle)
%-----------------------------------------------------------------
function [ColorLine, ColorState] = treeguistatecolinit(AxesHandle)
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
function ColorSelect = treeguistatenextcol(AxesHandle)
ColorSelectOrder = getappdata(AxesHandle, 'ColorSelectOrder');
ColorSelectInd   = getappdata(AxesHandle, 'ColorSelectInd');

ColorSelect = ColorSelectOrder(ColorSelectInd,:);
ColorSelectInd = 1 + mod(ColorSelectInd, size(ColorSelectOrder,1));
setappdata(AxesHandle, 'ColorSelectInd', ColorSelectInd);

%-----------------------------------------------------------------
function treeguistaterestoreprevcol(AxesHandle)
% Restore the previous color
ColorSelectOrder = getappdata(AxesHandle, 'ColorSelectOrder');
ColorSelectInd   = getappdata(AxesHandle, 'ColorSelectInd');

ColorSelectInd = 1 + mod(ColorSelectInd + size(ColorSelectOrder,1) -2, ...
	size(ColorSelectOrder,1));
setappdata(AxesHandle, 'ColorSelectInd', ColorSelectInd);

%-----------------------------------------------------------------
function [ColorLine, ColorState] = treeguistatedefcol(AxesHandle)
ColorState       = getappdata(AxesHandle, 'ColorState');
ColorLine        = getappdata(AxesHandle, 'ColorLine');

function nono
% Associate the line with it's parent
setappdata(LineHandles(iMark), ... 
	'StateHandle', ParentStateHandles(iMark));
