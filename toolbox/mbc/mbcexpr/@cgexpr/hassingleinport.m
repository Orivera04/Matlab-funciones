function [ret, pVar] = hassingleinport(obj)
%HASSINGLEINPORT Check whether an expression has a single independent inport
%
%  OK = HASSINGLEINPORT(OBJ) returns true if the expression OBJ has a
%  single inport, or all of its inports are dependent on each other (for
%  example a formula which depends on x, and x itself).
%  
%  [OK, pINPORT] = HASSINGLEINPORT(OBJ) also returns the inport if OK is
%  true.  If OK is false pINPORT will be an empty pointer array.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:08:53 $ 

pVar = getinports(obj);
if length(pVar)==1
    ret = true;
elseif length(pVar)==0
    ret = false;
elseif cgnumindependentvars(pVar)==1
    % Check whether all variables are dependent on each other
    ret = true;
    pVar = pVar(1);
else
    ret = false;
    pVar = null(xregpointer, 0);
end