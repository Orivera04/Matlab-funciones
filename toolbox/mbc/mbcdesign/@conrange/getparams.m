function p = getparams(c, type);
%GETPARAMS   Return parameters for object
%   S = GETPARAMS(C) returns a structure containing the parameters
%   for the constraint object C.  
%
%  S=GETPARAMS(C,'struct') returns the parameters in a structure.
%  S=GETPARAMS(C,'vector') returns the parameters in a row vector.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:45 $ 

if nargin < 2 || strcmpi( 'struct', type ),
    p = getparams( c.conbase );
    p.Center    = c.Center;
    p.HalfWidth = c.HalfWidth;
else % if strcmpi( 'vector', type ),
    p = [c.Center, c.HalfWidth];
end

return

% EOF
