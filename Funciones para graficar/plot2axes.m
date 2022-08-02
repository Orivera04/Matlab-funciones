function [ax, h] = plot2axes(varargin)

%PLOT2AXES Graphs one set of data with two sets of axes
%
%   PLOT2AXES(X, Y, 'Option1', 'Value1', ...) plots X versus Y with secondary
%   axes.  The following options are accepted [default values]:
%
%     XLoc ['top']: location of secondary X-axis
%     YLoc ['right']: location of secondary Y-axis
%     XScale [1]: scaling factor for secondary X-axis (scalar)
%     YScale [1]: scaling factor for secondary Y-axis (scalar)
%                 
%                 XScale and YScale can also be a character string
%                 describing the relationship between the 2 axes, such as
%                 the equation relating Celsius and Fahrenheit: '5/9*(x-32)'
%
%     XLim [NaN NaN] : XLim in the primary axes (secondary is adjusted
%                      accordingly). The default is naturally selected by
%                      the plotting function.
%     YLim [NaN NaN] : YLim in the primary axes (secondary is adjusted
%                      accordingly). The default is naturally selected by
%                      the plotting function.
%
%   PLOT2AXES(@FUN, ...) uses the plotting function @FUN instead of PLOT to
%   produce the plot.  @FUN should be a function handle to a plotting
%   function, e.g. @plot, @semilogx, @semilogy, @loglog ,@stem, etc. that
%   accepts the syntax H = FUN(...).  Optional arguments accepted by these
%   plotting functions are also allowed (e.g. PLOT2AXES(X, Y, 'r*', ...))
%
%   [AX, H] = PLOT2AXES(...) returns the handles of the primary and
%   secondary axes (in that order) in AX, and the handles of the graphic
%   objects in H.
%
%   The actual data is plotted in the primary axes.  The primary axes lie
%   on top of the secondary axes.  After the execution of this function,
%   the primary axes become the current axes.  If the next plot replaces
%   the axes, the secondary axes are automatically deleted.
%
%   When you zoom in or out using the toolbar, it would only zoom the
%   primary axes, so you should click on the 'Fix Axes' menu at the top of
%   the figure to re-adjust the secondary axes limits.
%
%   PLOT2AXES('FixAxes') fixes the secondary limits of all figures created
%   using plot2axes.
%   
%   Example 1:
%     x = 0:.1:1;
%     y = x.^2 + 0.1*randn(size(x));
%     [ax, h] = plot2axes(x, y, 'ro', 'YScale', 25.4);
%     title('Length vs Time');
%     set(get(ax(1), 'ylabel'), 'string', 'inch');
%     set(get(ax(2), 'ylabel'), 'string', 'millimeter');
%     xlabel('time (sec)');
%
%   Example 2:
%     [ax, h] = plot2axes(x, y, 'ro', 'YScale', '5/9*(x-32)');
%     set(get(ax(1), 'ylabel'), 'string', 'Fahrenheit');
%     set(get(ax(2), 'ylabel'), 'string', 'Celcius');
%
% VERSIONS:
%   v1.0 - first version
%   v1.1 - added option to specify X and Y limits
%   v1.2 - remove tick labels for secondary axes if no scaling factors are
%          specified. Also, fixed bug in matching the scaling type (linear
%          or log).
%   v1.3 - added the 'Fix Axes' menu for adjusting the secondary axes limits
%          after zooming.
%   v1.4 - added the option for specifying an equation for XScale and YScale
%          (June 2005)
%
% Jiro Doke (Inspired by ideas from Art Kuo)
% March 2005
%

if nargin < 1
  error('Not enough input arguments');
end

if nargin == 1 & strcmpi(varargin{1}, 'FixAxes')
  figsH = findobj('Type', 'figure');
  if ~isempty(figsH)
    for iFig = 1:length(figsH)
      p2a = getappdata(figsH(iFig), 'p2a');
      FixAxes([], [], p2a);
    end
  end
  return;
end

% Default options
options{1} = 'top';       % XLoc
options{2} = 'right';     % YLoc
options{3} = 1;           % XScale
options{4} = 1;           % YScale
options{5} = [NaN NaN];   % XLim
options{6} = [NaN NaN];   % YLim

opts = {'XLoc', ...
    'YLoc', ...
    'XScale', ...
    'YScale', ...
    'XLim', ...
    'YLim'};

var = varargin;

% Check to see if the first argument is a function handle
if isa(var{1}, 'function_handle');
  func = var{1};
  var(1) = '';
else
  func = @plot;
end

% Parse through input arguments for options
try
  removeID = [];
  for iVar = 1:length(var)
    if ischar(var{iVar})
      id = strmatch(lower(var{iVar}), lower(opts), 'exact');
      if ~isempty(id)
        options{id} = var{iVar + 1};
        removeID = [removeID, iVar, iVar + 1];
      end
    end
  end
catch
  error(sprintf('Error parsing options.\n%s\n', lasterr));
end

% Verify options
if ~ismember(lower(options{1}), {'top', 'bottom'}) | ...
    ~ismember(lower(options{2}), {'right', 'left'}) | ...
    ~(isnumeric(options{5}) & length(options{5}) == 2) | ...
    ~(isnumeric(options{6}) & length(options{6}) == 2)
  error('Bad options');
end

var(removeID) = '';

ax1 = newplot;
nextplot = get(ax1, 'NextPlot');

% Plot data
try
  h = feval(func, var{:});
catch
  error(sprintf('Failed to plot\n%s\n', lasterr));
end

set(ax1, 'Box', 'off', 'Color', 'none');

% Create secondary axes on top of primary axes
ax2 = axes('Position', get(ax1, 'Position'), 'Box', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply options
if strcmpi(options{1}, 'top') % XLoc
  set(ax1, 'XAxisLocation', 'bottom');
  set(ax2, 'XAxisLocation', 'top');
else
  set(ax1, 'XAxisLocation', 'top');
  set(ax2, 'XAxisLocation', 'bottom');
end

if strcmpi(options{2}, 'right') % YLoc
  set(ax1, 'YAxisLocation', 'left');
  set(ax2, 'YAxisLocation', 'right');
else
  set(ax1, 'YAxisLocation', 'right');
  set(ax2, 'YAxisLocation', 'left');
end

if ~all(isnan(options{5}))  % XLim
  set(ax1, 'XLim', options{5});
end
if ~all(isnan(options{6}))  % YLim
  set(ax1, 'YLim', options{6});
end

if ischar(options{3})
  tmp = inline(options{3});
  set(ax2, 'XLim', tmp(get(ax1, 'XLim')));
else
  set(ax2, 'XLim', get(ax1, 'XLim') * options{3})
end
if ischar(options{4})
  tmp = inline(options{4});
  set(ax2, 'YLim', tmp(get(ax1, 'YLim')));
else
  set(ax2, 'YLim', get(ax1, 'YLim') * options{4})
end

set(ax2, 'XScale', get(ax1, 'XScale'), ...
  'YScale', get(ax1, 'YScale'));

if options{3} == 1 % if there is no scaling, remove tick labels
  set(ax2, 'XTickLabel', '');
end
if options{4} == 1 % if there is no scaling, remove tick labels
  set(ax2, 'YTickLabel', '');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create DeleteProxy objects (an invisible text object) so that the other
% axes will be deleted properly.  <inspired by PLOTYY>
DeleteProxy(1) = text('Parent', ax1, ...
  'Visible', 'off', ...
  'HandleVisibility', 'off');
DeleteProxy(2) = text('Parent', ax2, ...
  'Visible', 'off', ...
  'HandleVisibility', 'off', ...
  'UserData', DeleteProxy(1));
set(DeleteProxy(1), 'UserData', DeleteProxy(2));

set(DeleteProxy, 'DeleteFcn', @DelFcn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Switch the order of axes, so that the secondary axes are under the primary
% axes, and that the primary axes become the current axes
ch = get(get(ax1, 'Parent'), 'Children'); % get list of figure children. ax1 and ax2 must exist in this list
i1 = find(ch == ax1);  % find where ax1 is
i2 = find(ch == ax2);  % find where ax2 is
ch([i1, i2]) = [ax2; ax1];  % swap ax1 and ax2
set(get(ax1, 'Parent'), 'Children', ch, 'CurrentAxes', ax1);  % assign the new list of children and set current axes to primary

% Restore NextPlot property (just in case it was modified)
set([ax1, ax2], 'NextPlot', nextplot);

% Store axes information
p2a = getappdata(get(ax1, 'Parent'), 'p2a'); if isempty(p2a); p2a = {}; end;
p2a = [p2a;{ax1, ax2, options{3}, options{4}}];
setappdata(get(ax1, 'Parent'), 'p2a', p2a);
% Create 'Fix Axes' button for adjusting the secondary axes limits after
% zooming
hMenu = findobj(get(ax1, 'Parent'), 'Type', 'uimenu', 'Label', 'Fix Axes');
if isempty(hMenu) | ~ishandle(hMenu)
  hMenu = uimenu('Parent', get(ax1, 'Parent'), 'Label', 'Fix Axes', 'callback', @FixAxes);
end

if nargout > 0
  ax = [ax1, ax2];
end


%%%%%%%%%%%%%%%%%%%%%%%%%
% @DelFcn
function DelFcn(obj, edata)

try
  set(get(obj, 'UserData'), 'DeleteFcn', 'try;delete(get(gcbo, ''UserData''));end');
  set(obj, 'UserData', get(get(obj, 'UserData'), 'Parent'));
  delete(get(obj,'UserData'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%
% @FixAxes
function FixAxes(obj, edata, p2a)

if nargin < 3
  p2a = getappdata(get(obj, 'Parent'), 'p2a');
end

if ~isempty(p2a)
  for iAx = 1:size(p2a, 1)
    if ishandle(p2a{iAx, 1}) & ishandle(p2a{iAx, 2})
      if ischar(p2a{iAx, 3})
        tmp = inline(p2a{iAx, 3});
        set(p2a{iAx, 2}, 'XLim', tmp(get(p2a{iAx, 1}, 'XLim')));
      else
        set(p2a{iAx, 2}, 'XLim', p2a{iAx, 3} * get(p2a{iAx, 1}, 'XLim'));
      end
      if ischar(p2a{iAx, 4})
        tmp = inline(p2a{iAx, 4});
        set(p2a{iAx, 2}, 'YLim', tmp(get(p2a{iAx, 1}, 'YLim')));
      else
        set(p2a{iAx, 2}, 'YLim', p2a{iAx, 4} * get(p2a{iAx, 1}, 'YLim'));
      end
    end
  end
end