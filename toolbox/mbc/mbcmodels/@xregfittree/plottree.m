function [out, out2] = plottree( Tree, action, varargin )
%XREGFITTREE/PLOTTREE   Plot of regression tree
%   PLOTTREE(TREE) produces a plot of the regression tree.
%
%   PLOTTREE(TREE,'Figure',MODEL,NAME,STRINGS) 
%  
%   STRINGS is an optinal cell array of strings to display when the user
%   clicks on any of the nodes of the tree. Some nodes can have no callback
%   by having empty strings for those nodes.
%
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.6.2 $  $Date: 2004/02/09 07:47:02 $

if nargin < 2,
    action = 'Figure';
end

switch lower( action ),
case 'enable',
    out = true;
case 'figure',
    out = i_CreateFigure( Tree, varargin{:} );
case 'layout',
    [out, out2] = i_CreateLayout( Tree, varargin{:} );
otherwise
    error( sprintf( 'Uknown option %s', action ) );
end

return

%------------------------------------------------------------------------------|
function figh = i_CreateFigure( Tree, model, modelname, strings )

if nargin < 4,
    strings = {};
end
if nargin < 3,
    modelname = '';
end
if nargin < 2,
    model = xregmodel( 'nfactors', size( Tree.XData, 2 ) );
end

i_deleteold;
figh = xregfigure( 'tag', i_hash_fig_tag, ...
    'Name', sprintf( 'Tree: %s', modelname ),...
    'Visible', 'Off' );
xregcenterfigure( figh, [600, 450] ); 
figh.MinimumSize = [600, 450];

[lyt, ud] = i_CreateLayout( Tree, figh );
ud.Tree = Tree;
ud.Model = model;

btnClose = uicontrol( 'Parent', figh,...
    'Style', 'PushButton',...
    'String', 'Close',...
    'Interruptible', 'off',...
    'Callback', 'delete( gcbf );' );

DividerLine = xregGui.dividerline( figh );

lyt = xreggridbaglayout( figh, ...
    'Dimension',[3, 3],...
    'RowSizes',[-1, 2, 25 ],...
    'ColSizes',[-1, 65, 65],...
    'GapY',5,...
    'GapX',7,...
    'Border',[5, 5, 5, 5],...
    'MergeBlock', { [1, 1], [1, 3] }, ...
    'MergeBlock', { [2, 2], [1, 3] }, ...
    'Elements', { ...
        lyt, [], []; ...
        DividerLine, [], []; ...
        [], [], btnClose } ); 
    
% tell the figure about all the data associated with it
set( figh, 'UserData', ud );

%
% All ready, turn it on
figh.LayoutManager = lyt;
set( lyt, 'packstatus', 'on' );
set( figh, 'visible', 'on' );

% Initialization
i_PlotTree( figh, strings );

return

%------------------------------------------------------------------------------|
function [lyt, ud] = i_CreateLayout( Tree, figh )

% pole plot axes and lines
ud.axes = xregaxes(...
    'Parent', figh,...
    'Visible', 'on', ...
    'Units', 'pixels',...
    'Box', 'on',...
    'XGrid', 'off',...
    'YGrid', 'off', ...
    'XlimMode', 'Manual', ... 
    'YlimMode', 'Manual', ...
    'XLim', [0, 1], ...
    'YLim', [0, 1], ...
    'XTick', [], ...
    'YTick', [], ...
    'PlotBoxAspectRatioMode', 'Auto' );

lyt = xregborderlayout( figh, ...
    'Border', [5, 5, 5, 5], ... % [W, S, E, N]
    'Center', ud.axes );

return

%------------------------------------------------------------------------------|
function i_PlotTree( figh, strings )
ud = get( figh, 'UserData' );

Tree = ud.Tree;
model = ud.Model;
xi = xinfo( model );
var = xi.Symbols;

p = getparent( Tree, ':' );
p = p(:)';

[x,y,h] = treelayout( p );
f = find( p~=0 );
pp = p(f);
X = [x(f); x(pp); repmat(NaN,size(f))];
Y = [y(f); y(pp); repmat(NaN,size(f))];
X = X(:);
Y = Y(:);

%  plot( X, Y, 'k-', 'Parent', ud.axes );
line( 'Parent', ud.axes, ...
    'XData', X, ...
    'YData', Y, ...
    'Color', 'k', ...
    'Marker', 'none', ...
    'LineStyle', '-' );

for i = 1:length( x ),
    ind = Tree.SplitDim(i);
    if ind ~= 0,
        [th, ph] = i_TextPatch( double( ud.axes ), var{ind}, [x(i),y(i)], 10, ...
            'CenterMiddle' );
    else,
        [th, ph] = i_TextPatch( double( ud.axes ), int2str( i ), ...
            [x(i),y(i)], 10, 'CenterMiddle' );
    end
    if ~isempty( strings ) && ~isempty( strings{i} ),
        % set up callback
        str = i_SetStringWidth( strings{i}, 40 );
        set( [th, ph], ...
            'ButtonDownFcn', { @i_TreeNodeButtonDown, figh }, ...
            'UserData', str );
    end
    set( [th, ph], 'Visible', 'on' );
end

return

%------------------------------------------------------------------------------|
function varargout = i_TreeNodeButtonDown( src, evt, figh )
% src is the patch or text object
ud = get( figh, 'UserData' );
axh = ud.axes;

% find where the user clicked
cp = get( axh, 'CurrentPoint' );
cp = cp(1,[1,2]); % only need x- any y-coordinates

%
% Display the patch
%
str = get( src, 'UserData' );
[th, ph] = i_TextPatch( axh, str, cp, 20, 'LeftBottom' );

set( ph, 'FaceColor', [1.0, 1.0, 0.8] );
set( [th, ph], 'Visible', 'on' );

oldUpFcn = get(gcbf ,'WindowButtonUpFcn');
set(gcbf, 'WindowButtonUpFcn', ...
    { @i_killtextpatch, ph, th, oldUpFcn } );

return

%------------------------------------------------------------------------------|
function [th, ph] = i_TextPatch( ax, infoStr, CP, height, align )
% ax      - axes handle
% infoStr - text to display
% CP      - current point, i,e., (x,y)-coordinates to place text patch at
% height  - z-coordinate to place patch object. Text object will be placed at 
%           z = height + 1
% align   - initial text alignment, either 'LeftBottom' or 'CenterMiddle'
%
% th - text handle
% ph - patch hanlde

set( ax, 'Layer', 'bottom'); % Draw axis lines below graphics objects

% save old ax units
oldUnits=get(ax,'units');

commonUnit = 'point';

% create the text to find out its extent and hence if it fits in the figure
ph = patch( 'Parent', ax, ...
    'FaceColor',[1, 1, 1],...
    'visible','off',...
    'EdgeColor','k',...
    'tag','dataPatch',...
    'FaceAlpha',1,...
    'clipping','off');

th = text(CP(1),CP(2),height+1,infoStr,...
    'Parent', ax,...
    'Visible','off',...
    'Units', 'data',...
    'FontName', 'Lucida Console',...
    'FontUnits', 'Points', ...
    'Clipping', 'off',...
    'Interpreter', 'none' );

switch lower( align ),
case 'leftbottom'
    set( th, 'HorizontalAlignment', 'left' );
    set( th, 'VerticalAlignment', 'bottom' );
case 'centermiddle',
    set( th, 'HorizontalAlignment', 'Center' );
    set( th, 'VerticalAlignment', 'Middle' );
otherwise
    % just use whatever the defaults are
end


%
% sort out text size (a bit!)
%
set( ax, 'Units', 'Points' );
ax_pos = get( ax, 'Position' );
axW = ax_pos(3); % axes width
axH = ax_pos(3); % axes height
maxFontSize = 8; % in 'points'
fsize = min( axH/size(infoStr,1), maxFontSize );
fsize = min( fsize, 1.7*axW /size(infoStr,2) );
% set text fontsize in 'point'
set( th, 'FontSize', fsize );

% now find how much space the text takes up
set( th, 'Units', 'Normalized' );
ext = get( th, 'extent' );

% adjust the text position so it fits inside the axes
axW = 1; % axes width
axH = 1; % axes height

if (ext(1)+ext(3))>axW %% goes off axes right
    if (ext(1)-ext(3))<0 %% will go off left if we right-align text
        Tpos = get(th,'position');
        set(th,'position',[0, Tpos(2), Tpos(3)]);
    else
        set(th,'HorizontalAlignment','right');
    end
end

if (ext(2)+ext(4))>axH %% goes off axes top
    if (ext(2)-ext(4))<0 %% goes off bottom
        Tpos = get(th,'position');
        set(th,'position',[Tpos(1), 0, Tpos(3)]);
    else
        set(th,'VerticalAlignment','top');
    end
end


% set position of the patch
set( ax, 'units', oldUnits );
set(th,'units','data');
ex = get(th,'Extent');
set(ph,...
    'XData', [ex(1), ex(1), ex(1)+ex(3), ex(1)+ex(3)],...
    'YData', [ex(2), ex(2)+ex(4), ex(2)+ex(4), ex(2)],...
    'ZData', repmat( height, [1,4] ) );

return

%------------------------------------------------------------------------------|
function i_killtextpatch(hFig, null, ph, th, oldUpFcn)
% Remove text and patch
% taken from mbcmodels/validate_rstool

set(gcbf ,'WindowButtonUpFcn',oldUpFcn);
delete(ph);
delete(th);

return

%------------------------------------------------------------------------------|
function c = i_SetStringWidth( c, n );

% turn many rowed string into a single row
c = reshape( c', 1, numel( c ) );

% divide string into lines of n characters
cout = {};
while length(c) > n
    c1 = fliplr(c(1:n));
    % line should end with '+'
    f= sort([findstr(c1,'+ ') findstr(c1,'- ')]);
    if ~isempty(f)
        c1 = fliplr(c1(f(1):end));
        c = c(length(c1)+1:end);
        if c1(1)==' ';
            c1= c1(2:end);
        end
        cout = [cout ; {c1}];
        % remainder of string
    else
        break
    end
end
if ~isempty( c ) & c(1) == ' ';
    c = c(2:end);
end
cout = [cout ; {c}];

c = deblank( char(cout) ); 

return

%------------------------------------------------------------------------------|
function i_deleteold
h = findobj( allchild(0), 'flat', 'tag', i_hash_fig_tag );
if ~isempty( h )
   h = handle( h );
   delete( h );
end
return
%------------------------------------------------------------------------------|
function s = i_hash_fig_tag
s = 'XregfittreePlotTree';
return
%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
