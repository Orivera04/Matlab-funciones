function p = getparams(c);
%GETPARAMS   Return parameters for object
%   S = GETPARAMS(C) returns a structure containing the parameters
%   for the constraint object C.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:45 $ 

p = getparams( c.conbase );
p.Model     = c.Model;
p.Center    = c.Center;
p.Transform = c.Transform;

return

% EOF
