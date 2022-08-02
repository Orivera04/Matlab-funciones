function [obj] = addPlot(obj, xVar, yVars, plotProperties)
%ADDPLOT A short description of the function
%
%  OBJ = ADDPLOT(OBJ, XVAR, YVARS, PLOT_PROPERTIES)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:19:13 $ 

% Ensure there are input variables
if nargin < 4
    plotProperties = getDefaultPlotProperties(sweepset);
end

if nargin < 3
    yVars = {};
end

if nargin < 2
    xVar = '';
end

% Make sure they are of correct types
if ischar(yVars) 
    yVars = {yVars};
end

% Add the data to the plots structure
obj.plots(end+1) = struct(...
    'xName', xVar...
    ,'yNames', {yVars}...
    ,'properties', plotProperties...
    );