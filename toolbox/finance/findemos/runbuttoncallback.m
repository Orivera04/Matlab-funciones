function [optimalParamaterEstimates , control , infoCellArray] = runbuttoncallback()
%RUNBUTTONCALLBACK Main differential evolutionary genetic algorithm callback.
%
%   [Estimates , Control , InfoData] = runbuttoncallback()
%
%   Inputs: None
%
%   Outputs:
%     Estimates: Optimal parameter estimate vector.
%     Control:   Summary control structure of the input parameters and results.
%     InfoData:  Information cell array for labeling plots with a mouse click.
%
%   See also DEGATOOL, GETSUMMARYINFO, DISPLAYSUMMARYINFO, DEGADEMO.

% Author(s): R.A. Baker, 06/18/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.9 $   $Date: 2002/04/14 21:45:55 $

h  =  findobj(0,'tag','DEwindow');       % Main DE figure window handle.

%
% Access all the DE control & population parameters.
%

fitnessFunction  = get(findobj(h , 'tag' , 'currentFitnessFunction') , 'string');

NP               = round(str2double(get(findobj(h , 'tag' , 'NPvalue') , 'string')));
nGenerations     = round(str2double(get(findobj(h , 'tag' , 'nGenerationsValue') , 'string')));
F                = str2double(get(findobj(h , 'tag' , 'Fvalue') , 'string'));
CR               = str2double(get(findobj(h , 'tag' , 'CRvalue') , 'string'));
similarityLimit  = str2double(get(findobj(h , 'tag' , 'similarityLimitValue') , 'string'));

for p = 1:10,
    xmin  = str2double(get(findobj(h , 'tag' , ['p'  num2str(p) 'min']) , 'string'));
    xmax  = str2double(get(findobj(h , 'tag' , ['p'  num2str(p) 'max']) , 'string'));
    if (~(isempty(xmin) | isempty(xmax))) & (xmin < xmax)
       parameterRanges(p,1:2) = [xmin xmax];
    else
       break
    end
end

%
% Run the optimization.
%

[optimalParamaterEstimates , population , ...
 similarityRatio           , control    ]  =  degademo(fitnessFunction , nGenerations , NP ,  ...
                                                       parameterRanges , F            , CR , similarityLimit);
%
% Initialize titles & labels for plotting.
%

plotTag    =  {'plotAverage'  
               'plotFittest'  
               'plotConvergence'};
xAxisLabel =  {'Generation'
               'Generation'
               'Generation'};
yAxisLabel =  {'Fitness' 
               'Fitness'
               'Convergence Criterion'};
plotTitle  =  {'Average Fitness of Each Generation' 
               'Fitness of the Best Individual' 
               'Population Convergence'};
%
% Initialize persistent variables. 'figureHandle' is the figure handle of any of the 
% attributes the user selected in the main DE window (i.e., the checkboxes actually 
% checked in the 'Graphical Analysis' frame). 'colorIndex' is just the index into the
% color plotting sequence vector set in the function 'DEplot'. By saving this value, we
% ensure that, for example, a mean fitness trial plotted in GREEN corresponds to a best
% fitness trial plotted in GREEN, regardless of how many mean fitness trials or best 
% fitness trials have been plotted. Example: The user checks 'Fittest Individual by 
% Generation', and a RED graph comes up in the correponding figure. The user then changes
% some parameters, check off 'Average Population Fitness by Generation' in addition to
% 'Fittest Individual by Generation', and reruns the analysis. Now the user will see see
% a RED and a GREEN plot in the first figure, and just a GREEN plot in the second figure.
% Although the first figure has 2 plot in it and the second figure has just 1 plot in it,
% the GREEN plot in each correspond to the same analysis run with the same set of parameters.
%

persistent  figureHandle  colorIndex

if isempty(figureHandle)
   figureHandle    =  [0  0  0];
end

if isempty(colorIndex)
   colorIndex  =  1;
end

%
% Construct the vector attributes to actually plot on each figure.
%

average  =  zeros(control.generation,1);  % Average population fitness per generation.
best     =  zeros(control.generation,1);  % Fittest member in the population per generation.
worst    =  zeros(control.generation,1);  % Least fit member in the population per generation.

for g = 1:control.generation
    average(g) =  mean(population(: , size(parameterRanges,1) + 1 , g));
    best   (g) =  max (population(: , size(parameterRanges,1) + 1 , g));
    worst  (g) =  min (population(: , size(parameterRanges,1) + 1 , g));
end

attribute      =  {average   best   similarityRatio(1:control.generation)};

infoCellArray  =  getsummaryinfo(control);   % Define the information summary text for this run.

for n = 1:length(plotTag)

    [colorIndex , figureHandle(n)] =  DEplot(h             , plotTag{n}      , xAxisLabel{n} , ...
                                             yAxisLabel{n} , plotTitle{n}    , attribute{n}  , ...
                                             colorIndex    , figureHandle(n) , infoCellArray);
end

colorIndex  =  colorIndex  +  1;

%
% Now plot the evolutionary progrssion.
%

if get(findobj(h , 'tag' , 'plotEvolution') , 'value'),

   plotFitnessFunction(fitnessFunction , population , control)

end



function [colorIndex , figureHandle] = DEplot(windowHandle , plotTag      , xAxisLabel   , ...
                                              yAxisLabel   , plotTitle    , attribute    , ...
                                              colorIndex   , figureHandle , infoCellArray)

colors = ['r' ; 'g' ; 'b' ; 'm' ; 'c' ; 'y'];

%
% Check to see of the 'Graphical Analysis' box corresponding to the the specified tag has 
% been checked. If it has, then plot the data; if it has NOT, then ignore it.
%

if get(findobj(windowHandle , 'tag' , plotTag) , 'value'),

%
%  The corresponding check box in the 'Graphical Analysis' frame has been checked. 
%  If the figure handle already exists AND the figure has NOT been closed, then just 
%  add this plot to the plots already there; if does has NOT already exist, then create
%  a new figure and plot it.
%
   if figureHandle  &  any(figureHandle == findobj('type' , 'figure'))

      figure(figureHandle)

      if colorIndex >= length(colors)
         colorIndex =  1;                % Ensure that we cycle through the color scheme. 
      end

   else

      figureHandle  =  figure(max(get(0,'children')) + 1);
%
%     Define the functions need to be evaluated to display the information 
%     summary text when the user clicks on line objects (and line objects only). 
%
      buttonDownFunction = ['hGCO  =  gco;'                                   , ...
                            'if strcmpi(get(hGCO, ''type''),''line''),'       , ...
                            '   displaysummaryinfo(get(hGCO, ''UserData''));' , ...
                            'end'];

      buttonUpFunction   = ['delete(findobj(gcf , ''tag'' , ''helpText''));'   , ...
                            'delete(findobj(gcf , ''tag'' , ''helpPatch''));'];
%      buttonUpFunction   = '';
      set(figureHandle , 'WindowButtonDownFcn' , buttonDownFunction , ...
                         'WindowButtonUpFcn'   , buttonUpFunction);

      set    (figureHandle , 'name'  , plotTitle , 'NumberTitle' , 'off');
      whitebg(figureHandle , 'black' )
      set    (figureHandle , 'color' , [0.2 0.7 0.7])
      xlabel (xAxisLabel   , 'color' , 'black');
      ylabel (yAxisLabel   , 'color' , 'black');
      title  (plotTitle    , 'color' , 'black');
      grid on

   end

   hold on
   lineHandle  =  plot(1:length(attribute) , attribute  , ['-' colors(colorIndex) '.'] , ...
                       'markersize' , 15   , 'UserData' , infoCellArray);
   hold off

end



function plotFitnessFunction(fitnessFunction , population , control)

%
% This function only makes sense if we have a 3-D graph (actually, it would make 
% sense for any number of dimensions, but then we would have to slice-n-dice the
% data, which I don't want to do right now).
%

if size(control.parameterRanges , 1) ~= 2 , return , end

%
% Extact the minimum & maximum axes limits in the X-Y plane.
%

xMin  =  control.parameterRanges(1,1);
xMax  =  control.parameterRanges(1,2);

yMin  =  control.parameterRanges(2,1);
yMax  =  control.parameterRanges(2,2);

%
% Evaluate the 3-D objective (fitness) function to produce X, Y, and Z matrices amenable to SURF plots.
%

matrixSize  =  50;

[x,y]  =  meshgrid(linspace(xMin , xMax , matrixSize) , linspace(yMin , yMax , matrixSize));

z      =  reshape(feval(fitnessFunction , [x(:) y(:)] , control.parameterRanges) , matrixSize , matrixSize);

%
% Plot the 3-D surface (create a new figure window if necessary, or else use the 
% existing one if it's handle still exists AND the figure has NOT been closed).
%

persistent figureHandle  axisHandle

if ~isempty(figureHandle) & any(figureHandle == findobj('type' , 'figure'))
   figure(figureHandle)
else
   figureHandle  =  figure(max(get(0,'children')) + 1);
   colormap('autumn')
   axisHandle  =  axes;
   view    (3);
   whitebg (figureHandle , 'black')
   set     (figureHandle , 'name' , 'Evolutionary Progression' , 'NumberTitle' , 'off' , 'color' , [0.2 0.7 0.7])
%   set     (figureHandle , 'renderer' , 'OpenGL')
end

surfaceHandle  =  surf(x , y , z);

set   (surfaceHandle , 'FaceColor' , 'interp')
set   (surfaceHandle , 'EdgeColor' , 'interp')
xlabel('X-Axis (Parameter 1)' , 'color' , 'black')
ylabel('Y-Axis (Parameter 2)' , 'color' , 'black')
zlabel('Z-Axis (Fitness)'     , 'color' , 'black')
title ('Evolutionary Progression: Population Fitness vs. Generation' , 'color' , 'black')

axes(axisHandle)
axis([xMin xMax yMin yMax -inf inf])   % Hard-code axis limits so the surface doesn't shrink and expand.
hold on                                % Add successive generations on top of the objective function.

%
% Plot the first generation in discrete form, then update the plot with each successive generation
% to capture the effect an 'evolutionary progression' for the population.
%

plot3(population(:,1,1) , population(:,2,1) , population(:,3,1) , '.b' , 'markersize' , 13)

for g = 2:control.generation

    lineObjects  =  findobj(axisHandle , 'Type', 'line');
%
%   Prune all points that lie outside the X-Y plane. The data is correct, but
%   they produce some rather visually unappealing results. The outliers are
%   encoded as NaN's, which are then ignored by the plotting routines.
%
    pointsOutsideBox          =  find((population(:,1,g) < xMin | population(:,1,g) > xMax)  | ...
                                      (population(:,2,g) < yMin | population(:,2,g) > yMax));
    zValue                    =  population(:,3,g);
    zValue(pointsOutsideBox)  =  NaN;

    set(lineObjects , 'XData' , population(:,1,g) , ...
                      'YData' , population(:,2,g) , ...
                      'ZData' , zValue);
    drawnow

end

hold off
