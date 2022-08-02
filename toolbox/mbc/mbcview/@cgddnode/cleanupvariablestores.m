function obj = cleanupvariablestores(obj, validstores)
%CLEANUPVARIABLESTORES Cleanup unused stores from variables
%
%  OBJ = CLEANUPVARIABLESTORES(OBJ, VALIDSTORES) removes all stores that
%  are not listed in VALIDSTORES from all variables.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:23:08 $ 

passign(obj.ptrlist, pveceval(obj.ptrlist, @removestoresexcept, validstores));