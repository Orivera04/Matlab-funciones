function obj = unique(obj, obj1)
%GUIDARRAY/UNIQUE generate a unique guidarray from two inputs
%
%  UNIQUEARRAY = UNIQUE(ARRAY1, ARRAY2)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:03:50 $ 

% Check inputs are correct types
if ~isa(obj, 'guidarray') && ~isa(obj1, 'guidarray')
    error('mbc:guidarray:InvalidArgument', 'Inputs to unique must be guidarray''s');
end

% Concatenate the two inputs
obj.values = [obj.values ; obj1.values];
% Make the array unique 
obj.values = unique(obj.values);
% Update the hash
obj = updateHash(obj);