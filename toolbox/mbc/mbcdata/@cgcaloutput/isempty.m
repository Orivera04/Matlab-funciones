function ret = isempty(obj)
%ISEMPTY Check whether there is anything to export
%
%  ISEMPTY(OBJ) returns true if there are no objects in the pointer list
%  for exporting.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:49:29 $ 

ret = isempty(obj.ptrlist);