function setActiveFigures(this)
% SETACTIVEFIGURES 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/19 01:33:10 $

% Get plot info
plotTypes = this.Fields.Plots(:,2);
plotNames = this.Fields.Plots(:,3);
plotVis   = ~strcmp( plotTypes, '(none)' );

% Set visibility of figures
for ct = 1:length(plotVis)
  fig = this.Views(ct); % Figure handle

  % Create figure if it does not exist
  if ~ishandle(fig)
    fig = handle(figure);
    set( fig, 'Visible',          'off', ...
              'HandleVisibility', 'off', ...
              'NumberTitle',      'off', ...
              'CloseRequestFcn',  @(x,y) LocalHide(fig) )
    
    % Listener to parent deletion
    L = handle.listener( this, 'ObjectBeingDestroyed', @(x,y) LocalDelete(fig) );
    
    % User data
    UD = struct('Type', '', 'Plot', [], 'Listener', L);
    set(fig, 'UserData', UD)
  end
  
  % Plot data stored in figure's userdata
  UD = get(fig, 'UserData');
  
  if plotVis(ct)
    % Make visible for new plots or when plot type changes
    if isempty( UD.Plot ) || ~strcmp( UD.Type, plotTypes{ct} )
      fig.Visible = 'on';
    end
  else
    % Delete plot
    delete( UD.Plot(ishandle(UD.Plot)) )
    UD.Plot = [];
    UD.Type = '';
    set(fig, 'UserData', UD);
    fig.Visible = 'off';
  end
  
  fig.Name = sprintf( '%s - Plot %d (%s) : %s', this.Label, ct, ...
                      plotTypes{ct}, plotNames{ct} );
  this.Views(ct) = fig;
end

% --------------------------------------------------------------------------
function LocalHide(fig)
% Make figure invisible
set(fig, 'Visible', 'off');

function LocalDelete(fig)
% Deletes figure when view panel goes away
delete(fig)
