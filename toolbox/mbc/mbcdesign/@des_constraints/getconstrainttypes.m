function cons=getconstrainttypes(obj)
%GECONSTRAINTTYPES
%
%  CONS=GETCONSTRAINTTYPES(OBJ)  returns a cell array
%  containing the constructor names for all of the known
%  constraint types.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:52 $

cons={
   'conlinear'
   'conellipsoid'
   'contable1'
   'contable2'
};