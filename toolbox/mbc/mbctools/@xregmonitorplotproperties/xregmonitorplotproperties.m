function obj = xregmonitorplotproperties(arrayLength)
%XREGMONITORPLOTPROPERTIES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $   $Date: 2004/02/09 08:19:23 $


obj.plots = struct(...
    'xName', {}...
    ,'yNames', {}...
    ,'properties', {}...
    );

% Object version
obj.version = 1;

% Create the object
obj = class(obj, 'xregmonitorplotproperties');

