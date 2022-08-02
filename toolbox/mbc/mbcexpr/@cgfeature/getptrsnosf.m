function p = getptrsnosf(e)
%GETPTRSNOSF  Return pointers except for those in features
%
%  PTRS = GETPTRSNOSF(OBJ) returns all pointers it contains unless this is
%  a sub feature in which case it returns nothing.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:40 $

p = [];