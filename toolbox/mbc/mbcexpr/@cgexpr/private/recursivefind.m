function pItems = recursivefind(obj, hFcnToCheck)
%RECURSIVEFIND Private method for recursively checking items in an expression
%
%  pITEMS = RECURSIVEFIND(OBJ, FCNHNDL) goes down the expression chain
%  recursively finding the inputs of OBJ that return true when the function
%  FCNHNDL is evalauted on them.  Note that this function cannot return OBJ
%  itself as a matching input becuase the pointer is not available,
%  therefore you may need to check the status of OBJ before calling this
%  routine.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:09:45 $

ptrs = getinputs(obj);
if ~isempty(ptrs)
    ports = pveceval(ptrs, hFcnToCheck);
    ports = [ports{:}];
    if ~all(ports)
        subports = pveceval(ptrs(~ports), @recursivefind, hFcnToCheck);
        pItems = [ptrs(ports), subports{:}];
    else
        pItems = ptrs;
    end
    pItems = unique(pItems);
else
    pItems = null(xregpointer, 0);
end
