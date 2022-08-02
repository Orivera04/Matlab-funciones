function obj = mbccellstore(store)
%MBCCELLSTORE Constructor for mbccellstore object
%
%  OBJ = MBCCELLSTORE constructs a new mbccellstore object.  This is a
%  child class of MBCSTORE that stores data in a cell array, allowing
%  dis-similar data items to be stored next to each other.
%
%  OBJ = MBCCELLSTORE(STORE) constructs a new mbccellstore by converting
%  the data contained in the mbcstore STORE into a cell array.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:43:57 $ 


if nargin
    [keys, data] = getallvalues(store);
    data = num2cell(data);
    store = mbcstore;
    store = setvalue(store, keys, data);
else
    store = mbcstore;
end

obj.version = 1;
obj = class(obj, 'mbccellstore', store);