function dd = dragndrop(hFig,varargin);
%DRAGNDROP  Implement Drag and Drop components of a user interface
%   dd = dragndrop(hFig) creates a drag and drop object on figure hFig
%
% DRAGNDROP is designed to allow you to easily add drag and drop
% functionality to your MATLAB-based applications.  There are two basic
% components of a drag and drop interface: The draggable sources and the
% drop targets.  Callbacks are associated with each target which allow you
% to define how MATLAB should behave when sources are dropped on the
% targets.  Each target can have it's own list of valid sources, providing
% you with the flexibility to restrict the user's actions to those you deem
% reasonable (without having to do a lot of management in the callback).
%
% DRAGNDROP is implemented with the DRAGNDROP object.  The object is
% associated with the figure containing the sources and targets
% (cross-figure dragndrop is not yet supported).  All properties of the
% dragndrop interface are configured through the dragndrop object using the
% familiar set/get interface of handle graphics (almost)
%
% GET(DD) returns the values of all properties of DRAGNDROP object DD as a
% structure.
% GET(DD,'Property') returns the value of the specified property
% SET(DD,'Property',Value) sets 'Property' of DD to Value.
% SET(DD,'P1','V1','P2','V2',...) sets multiples properties
% SET(DD) gives you some idea of the supported formats for each property
%
% Creating a DRAGNDROP object:
% dd = DRAGNDROP creates a dragndrop object on the current figure.
% dd = DRAGNDROP(hFig) creates a dragndrop object on the figure with handle
% hFig.  
% dd = DRAGNDROP(hFig,'P1','V1','P2','V2', ...) sets the properties P1, P2,
% ... to values V1, V2, ... respectively
%
%
% DRAGNDROP property summary:
% 4 parameters must be defined to establish the drag and drop interface:
% DragHandles:   Handles to the draggable source objects
% DropHandles:   Handles to the drop targets
% DropCallbacks: The callbacks associated with each drop target
% DropValidDrag: The associations of which draggable source objects can be
% associated with with drop targets.  Yeah, I know that this needs a better
% name.  Any ideas?
%
% There is one additional read-only properties of the dragndrop object:
% Parent:        The handle to the parent fiure of the dragndrop object
%
%
% DRAGNDROP property details:
% 
% DragHandles:   Handles to the draggable source objects 
% DragHandles is specified as an array of handles to draggable sources.  Axes and
% uicontrols can be defined as draggable sources.  This should be ALL
% draggable sources on your figure window.  We'll deal with associations
% with DropValidDrag.
%
% DropHandles:   Handles to the drop targets
% DropHandles is specified as an array of handles to drop targets.  Axes and
% uicontrols can be defined as drop targets.  This should be ALL drop
% targets on your figure window.  We'll deal with associations
% with DropValidDrag.  Drop targets can not be directly subdivided (i.e.,
% different regions of an axis).  If you really want to do this, try
% defining some well-placed invisible controls as the drop targets.
%
% DropCallbacks: The callbacks associated with each drop target
% DropCallbacks is specified as a handle to a callback function, or a cell
% array of function handles.  I'm sorry if you prefer using strings to
% specify functions, but that's such a pain to handle that I'm requiring
% function handles.  Get over it and learn function handles (@) - they are
% great!
% If you specify a single callback function, it will be applied to all drop
% targets.  If you would like different drop targets to have different
% callbacks, use a cell array of function handles.  There must be one
% function handle for each drop target.  These are applied in the order in
% which your drop targets were specified.  i.e., the first function handle
% applies to the first element of DropHandles and so on.
%
% The callback functions have two required input arguments: drag and drop.
% I'd like to allow you to add your own input arguments, but I haven't done
% that yet. So, the typical callback function header looks like:
%   function MyCallback(drag,drop)
% drag is the handle to the object that was dragged.
% drop is the handle to the target where it was dropped.
% 
% DropValidDrag: The associations of which draggable source objects can be
% associated with with drop targets. 
% The format's a little tricky, so bear with me.  You specify a cell array,
% with one element for each drop target (a la Drop Callbacks).  Each
% element of the cell array is a numerical array of handles to the sources
% valid for each target.  These values must all be specified in DragHandles. 
%  Ex: set(dd,'DropValidDrag',{[drag1 drag2],drag2}) will allow drag1 and
%  drag2 to be dropped on the first drop target, but only drag2 to be
%  dropped on the second drop target.
% You are probably saying - this is a real pain for when I just want to
% allow all sources to be dropped on all targets.  I agree, so there's an
% shortcut: set(dd,'DropValidDrag','all')
%
%
% Warnings:
% I'm not a professional developer.  As such, I don't put in all of the
% fancy niceties.  Here are some "features" you might want to watch out
% for:
%
%  - The order in which you specify Property-Value pairs is important.  I
%  know this is ridiculous, but it's a lot easier to program.  Just be sure
%  to define the drag and drop targets (DragHandles, DropHandles)  before you 
% define the callbacks and the source-target mapping (DragCallbacks,
% DropValidDrag).
% - Dragging of lines (and other axes children) is not supported.  It would
% be nice, but it's not.  Instead, I treat dragging an axes child the same
% as dragging the axes itself.
% - Be careful about putting controls on or near each other.  This can mess
% up the hit test for when you click on the boundary of an object.  I ran
% into difficulties when I placed a popupmenu on a frame.  You click inside
% the popupmenu to use it, and on the edge to drag it.  Well, the edge of
% the popupmenu is actually the active part of the frame.  The solution is
% to set the frame to be inactive (set(hFrame,'Enable','inactive'))

% Scott Hirsch
% 7/03
% TODO: Implement cross-figure dragndrop
%       Support additional arguments in DropCallback
%       Special behavior for listbox - drag selection; callback indicates
%       selection.  Allow for multiselect, too.



if nargin == 0  %Default constructor.  Use current figure
    hFig = gcf;
end;

if isa(hFig,'dragndrop')    %Return object
    dd = hFig;
    return
end;

%Confirm validity of hFig
if ~ishandle(hFig)
    error('First argument must be a valid figure handle');
end;

if ~strcmp(get(hFig,'Type'),'figure');
    error('First argument must be a valid figure handle');
end;


%Create default object
dd.DragHandles = [];
dd.DropHandles = [];
dd.DropCallbacks = {};
dd.DropValidDrag = {};

%Read-only properties
dd.Parent = hFig;           %Locked at runtime

%Define class
dd = class(dd,'dragndrop');

%Create application data on figure
setappdata(hFig,'dragndrop',dd);

%Parse PV pairs.  Limitation: Must specify draghandles before dropvaliddrag
if nargin>2
    dd = set(dd,varargin{:});
end;



    