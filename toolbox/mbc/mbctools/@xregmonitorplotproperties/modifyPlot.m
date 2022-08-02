function [obj] = modifyPlot(obj, index, xVar, yVars, plotProperties)
%MODIFYPLOT A short description of the function
%
%  OBJ = MODIFYPLOT(OBJ, INDEX, XVAR, YVARS, PLOT_PROPERTIES)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:19:17 $ 

% Ensure there are input variables
if nargin < 5
    plotProperties = [];
end

if nargin < 4
    yVars = {{}};
end

if nargin < 3
    xVar = '';
end

% Make sure they are of correct types
if ischar(yVars)
    yVars = {yVars};
end

% Ensure the index is valid
if index > length(obj.plots) || index < 0
    error('mbc:xregmonitorplotproperties:InvalidIndex', 'Index out of range');
end

% Add the data to the plots structure
obj.plots(index) = struct(...
    'xName', xVar...
    ,'yNames', {yVars}...
    ,'properties', plotProperties...
    );