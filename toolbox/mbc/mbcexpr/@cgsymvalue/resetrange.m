function obj = resetrange(obj)
%RESETRANGE Check that the nominal value is within the range
%
%  OBJ = RESETRANGE(OBJ) checks that the nominal value of the symvalue is
%  within it's range.  If not, the range is expanded to include it.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:15:57 $

R = getrange(obj);
NV = getnomvalue(obj);
if NV > R(2) 
    R(2) = NV;
elseif NV < R(1)
    R(1) = NV;
end
obj = setrange(obj, R);