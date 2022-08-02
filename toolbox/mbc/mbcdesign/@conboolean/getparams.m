function p = getparams(c);
%GETPARAMS   Return parameters for object
%   S = GETPARAMS(C) returns a structure containing the parameters
%   for the constraint object C.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:30 $ 

p = getparams( c.conbase );
p.Constraints = c.Constraints;
p.Not         = c.Not;
p.Op          = c.Op;


% EOF
