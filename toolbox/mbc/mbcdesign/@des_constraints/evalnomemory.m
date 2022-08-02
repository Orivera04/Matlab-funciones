function in=evalnomemory(c,pts)
%EVALNOMEMORY  Evaluate points without remembering their state
%
%  in=evalnomemory(c,pts)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:49 $

% pass on call to main eval.  Only the second output is used
[c,in]=eval(c,pts,0,0);
