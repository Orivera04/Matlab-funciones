function dataplot(this, h, manager)
% DATAPLOT Plots the experiment data for a selected I/O port.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/16 22:20:35 $

% Port data
time = h.Time;
data = h.Data;

% Check for invalid data
if isempty(data) || isempty(time)
  str = sprintf('Invalid data entered for block ''%s''.', h.Block);
  errordlg(str, 'Plot Error', 'modal')
  return
end

% Reshape data
nd = length(h.Dimensions);
nc = prod(h.Dimensions);
if nd > 1
  data = reshape( permute(data, [nd+1,1:nd]), [length(time), nc] );
end

% Styles
Colors = {'b','g','r','m','c','y'};

% Create figure
fig = handle(figure);
set( fig, 'HandleVisibility', 'off', ...
          'NumberTitle',      'off', ...
          'Name', sprintf('%s - %s', this.Label, h.Block) );

% Create axis
ax    = axes('Parent', fig);
title = sprintf('Data plot for port \n%s', h.Block);
set( get(ax, 'Title'),  'String', title, 'Interpreter', 'none');
set( get(ax, 'XLabel'), 'String', 'Time', 'Interpreter', 'none');
set( get(ax, 'YLabel'), 'String', 'Amplitude', 'Interpreter', 'none');

% Listener to parent deletion
L = handle.listener( this, 'ObjectBeingDestroyed', {@LocalDelete, fig} );
UD = struct('Listener', L);
set(fig, 'UserData', UD)

% Create lines
L = zeros(nc,1);
for ct = 1:nc
  c = Colors{ 1 + rem(ct-1,length(Colors)) };
  
  L(ct) = line('Parent', ax, 'Color', c, ...
               'LineWidth', 1, 'LineStyle', '-');
  b = hggetbehavior(L(ct), 'DataCursor');
  Context = struct( 'DataSize', h.Dimensions, ...
                    'Channel',  ct);
  b.UpdateFcn = @(tip,cursor) LocalMakeTip(tip,cursor,Context);
  
  set(L(ct), 'XData', time, 'YData', data(:,ct))
end

% Turn on datatips
dcm = datacursormode(fig);
set(dcm, 'Enable', 'on', 'SnapToDataVertex', 'off');

% --------------------------------------------------------------------------
function str = LocalMakeTip(DataTip, DataCursor, Context)
% Cursor position
Location = { sprintf( 'Time: %.3g', DataCursor.Position(1) ) ; ...
             sprintf( 'Amplitude: %.3g', DataCursor.Position(2) ) };

% Signal size
DataSize = Context.DataSize;
if isequal(DataSize, 1)
  ChStr = '';
elseif any( DataSize == 1 ) || (length(DataSize) == 1)
  ChStr = sprintf(', channel %d ', Context.Channel);
else
  [i,j] = ind2sub(DataSize, Context.Channel);
  ChStr = sprintf(', channel (%d,%d) ', i, j);
end

% Header
Head = { sprintf('Experiment data%s', ChStr) };
str  = cat(1, Head, Location);

% --------------------------------------------------------------------------
function LocalDelete(hSrc, hData, fig)
% Deletes figure when node goes away
delete(fig)
