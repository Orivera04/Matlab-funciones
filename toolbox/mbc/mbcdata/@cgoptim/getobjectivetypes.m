function objs = getobjectivetypes(optim)
% GETOBJECTIVETYPES
%
%  OBJS=GETOBJECTIVETYPES(OPTIM)  returns a cell array
%  containing the constructor names for all of the supported
%  objective types for OPTIM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:23 $

if allowsums(optim) && ~isempty(optim.oppoints) && any(isvalid(optim.oppoints))
   objs={
   'cgobjectivefunc'
   'cgobjectivesum'
   };
else
   objs = {'cgobjectivefunc'};
end
    
