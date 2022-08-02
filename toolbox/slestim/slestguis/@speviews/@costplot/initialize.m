function initialize(this, fig, varargin)
% Initialize graphics

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:40:55 $

% Create and configure axes
ax = axes('Parent',fig,'Visible','off');
LocalSetPreferences(this, ax)

% Generic property init
gridsize = [1 1];
init_prop(this, ax, gridsize);

% User-specified initial values (before listeners are installed...)
set(this, varargin{:});

% Create @axesgrid object
this.AxesGrid = ctrluis.axesgrid(gridsize, ax, ...
   'Title',  'Cost Function', ...
   'XLabel', 'Iterations', ...
   'YLabel', 'Cost', ...
   'YScale', 'log' ,...
   'Visible', this.Visible,...
   'LimitFcn',  {@updatelims this} );
this.AxesGrid.RowLabelStyle.Interpreter = 'none';

% Add listeners
addlisteners(this)

% Delete datatips when the axis is clicked
set( allaxes(this), 'ButtonDownFcn', {@LocalButtonDown, this})

% ----------------------------------------------------------------------------- %
function LocalButtonDown(hSrc, hData, this)
defaultButtonDownFcn(this, hSrc)

% ----------------------------------------------------------------------------- %
function LocalSetPreferences(this, ax)
% Apply preferences to AX
if isunix
    FontSize  = 10;
else
    FontSize  = 8;
end

set( ax, 'XGrid', 'off', ...
         'YGrid', 'off', ...
         'XColor', [0.4 0.4 0.4], ...
         'YColor', [0.4 0.4 0.4], ...
         'FontSize', FontSize, ...
         'FontWeight', 'normal', ...
         'FontAngle', 'normal', ...
         'Selected', 'off');

set( get(ax, 'Title'), 'FontSize', FontSize, ...
                       'FontWeight', 'normal', ...
                       'FontAngle', 'normal');

set( [ get(ax,'XLabel'), get(ax,'YLabel') ],...
     'Color', [0 0 0],...
     'FontSize',   FontSize, ...
     'FontWeight', 'normal', ...
     'FontAngle',  'normal');
