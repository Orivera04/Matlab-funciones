function [obj] = deletePlot(obj, index)
%DELETEPLOT A short description of the function
%
%  OUT = DELETEPLOT(IN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:19:19 $ 

% Ensure the index is valid
if any(index > length(obj.plots)) || any(index < 0)
    error('mbc:xregmonitorplotproperties:InvalidIndex', 'Index out of range');
end

% Add the data to the plots structure
obj.plots(index) = [];