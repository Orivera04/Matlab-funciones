function [types,strings] = precision_classes;
%PRECISION_CLASSES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:56:37 $

% [TYPES,STRINGS] = PRECISION_CLASSES returns two cells of strings. TYPES contains the
% class names of the current precision objects inside CAGE, strings returns descriptive
% strings.

types = {'cgprecfloat',...
        'cgprecpolyfix',...
        'cgpreclookupfix'};

strings = {'Floating Point',...
        'Polynomial Ratio, Fixed Point',...
        'Lookup Table, Fixed Point'};

return