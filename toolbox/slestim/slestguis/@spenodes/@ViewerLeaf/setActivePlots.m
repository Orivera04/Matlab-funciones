function setActivePlots(this)
% SETACTIVEPLOTS 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/19 01:33:11 $

% Get selected plot types
plotTypes = this.Fields.Plots(:,2);
plotVis   = ~strcmp( plotTypes, '(none)' );
plotIdxs  = find( plotVis );

% Get plot options for each estimation
estimIdxs = cell2mat( this.Fields.Options(:,2:end) );

% Get current estimation & variable nodes
hEsts = find(this.getRoot, '-class', 'spenodes.EstimationLeaf');
hPars = find(this.getRoot, '-class', 'spenodes.Variables');
hExps = LocalAllExperiments(this); % Numerical experiment object

% Check for valid estimations and data sets
if isempty(hExps) || isempty(hEsts)
  warnmsg = sprintf( ['Configure your data sets and estimations ' ...
                      'before creating plots for %s.'], this.Label );
  uiwait( warndlg( warnmsg, 'View Warning', 'modal') );
end

% Get estimation objects
Estimations = handle( NaN(size(hEsts)) );
for ct = 1:length(hEsts)
  Estimations(ct) = hEsts(ct).Estimation;
end

% Create plots
for ct2 = 1:length(plotIdxs)
  idx = plotIdxs(ct2);
  plotType = plotTypes{idx};
  
  fig = this.Views(idx);
  UD  = get(fig, 'UserData');
  
  try
    hPlot = LocalCreatePlot(this, fig, plotType, hPars, hExps);
  catch
    hPlot = UD.Plot;
    delete( hPlot(ishandle(hPlot)) )
    fig.Visible = 'off';
    continue; % Don't try to add to this plot
  end
  
  UD.Plot = hPlot;
  UD.Type = plotType;
  set(fig, 'UserData', UD);
  
  try
    for ct1 = 1:length(Estimations)
      Estimation = Estimations(ct1);
      
      % Add a new plot if necessary
      need2add = LocalNeed2Add(hPlot, Estimation);
      if estimIdxs(ct1, idx)
        if need2add
          hPlot.addestim(Estimation);
        end
      else
        if ~need2add
          hPlot.rmestim(Estimation);
        end
      end
    end
    
    % Update plot
    hPlot.draw
  catch
    errmsg = sprintf( '''%s'' plot for %s cannot be created.', ...
                      plotType, Estimation.Description);
    uiwait( errordlg( errmsg, 'Error Creating Plots', 'modal') );
    delete( hPlot(ishandle(hPlot)) )
  end
end

% --------------------------------------------------------------------------
% Determine whether Estimation should be added to the plot
function flag = LocalNeed2Add(hPlot, Estimation)
flag  = false;
Waves = hPlot.allwaves;

for ct = 1:length(Waves)
  if ~isempty(Waves(ct).DataSrc) && (Waves(ct).DataSrc.Estimation == Estimation)
    % Already there
    return
  end
end

% Add
flag = true;

% --------------------------------------------------------------------------
function hPlot = LocalCreatePlot(this, fig, plotType, hPars, hExps)
UD = get(fig, 'UserData');
hPlot = UD.Plot;

plotClass = class(hPlot);
switch plotType
case 'Cost function'
  if ~strcmp( plotClass, 'speviews.costplot' )
    delete( hPlot(ishandle(hPlot)) )
    hPlot = speviews.costplot(fig);
  end
case 'Parameter sensitivity'
  if ~strcmp( plotClass, 'speviews.gradientplot')
    delete( hPlot(ishandle(hPlot)) )
    hPlot = speviews.gradientplot(fig, hPars.Parameters);
  else
    hPlot.AllParameters = hPars.Parameters;
  end
case 'Parameter trajectory'
  if ~strcmp( plotClass, 'speviews.paramplot')
    delete( hPlot(ishandle(hPlot)) )
    hPlot = speviews.paramplot(fig, hPars.Parameters);
  else
    hPlot.AllParameters = hPars.Parameters;
  end
case 'Measured and simulated'
  if ~strcmp( plotClass, 'speviews.simplot')
    delete( hPlot(ishandle(hPlot)) )
    hPlot = speviews.simplot(fig, hExps);
  end
case 'Residuals'
  if ~strcmp( plotClass, 'speviews.residplot')
    delete( hPlot(ishandle(hPlot)) )
    hPlot = speviews.residplot(fig, hExps);
  end
otherwise
  str = sprintf('%s plots are not currently supported', plotType);
  beep
  uiwait( errordlg(str) );
  close( fig )
end

% --------------------------------------------------------------------------
function experiments = LocalAllExperiments(this         )
parent = find(this.getRoot, '-class', 'spenodes.TransientData');
h = find( parent, '-class', 'spenodes.TransientDataLeaf' );

% Evaluate experiments
experiments = [];
for ct = 1:length(h)
  experiments = [ experiments; ...
                  evalForm( h(ct).Experiment, copy(parent.Experiment) ) ];
  experiments(end).Description = h(ct).Experiment.Description;
end
