function result = GetSubset(obj, index)
% DESIGNDEV/GETSUBSET a private method to create 
% a new designdev object from indicies into an existing obj

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:03 $

% Get the DesignDev cell array
objs = DesignDev2Cell(obj);

% Re-create DesignDev object
result = Cell2DesignDev(objs(index));


