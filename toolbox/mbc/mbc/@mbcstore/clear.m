function obj = clear(obj)
%CLEAR Remove all values from store
%
%  OBJ = CLEAR(OBJ) removes all of the value and key information from the
%  store.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:24 $ 

obj.KeyList = [];
obj.DataList = [];