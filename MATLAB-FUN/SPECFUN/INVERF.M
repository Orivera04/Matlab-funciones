function b = inverf(x)
%INVERF	Inverse Error function.

% 	For backward compatibility.  Calls ERFINV.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp('This usage of inverf(X) is obsolete and will be eliminated')
disp('in future versions. Please use erfinv(X) instead.')
b = erfinv(x);

