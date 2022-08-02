function cons=getconstrainttypes(obj)
%GETCONSTRAINTTYPES List of avaliable constraint types
%
%  CONS=GETCONSTRAINTTYPES(OBJ)  returns a cell array containing the
%  constructor names for all of the constraint types that work with this
%  OBJ.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:13:04 $

cons={
   'constar'
   'conellipsoid'
   'conrange'
};
