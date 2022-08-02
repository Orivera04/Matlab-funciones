function obj = mapptr(obj,RefMap);
%MAPPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:55:50 $

% Changes instance of oldptr to newptr 

obj.modptr = mapptr(obj.modptr,RefMap);
