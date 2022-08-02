function mode = getConstraintsMode(obj)
%GETCONSTRAINTSMODE Return the current usage of constraints.
%   MODE = GETCONSTRAINTSMODE(OPTIONS) returns a string describing how the
%   optimization makes constraints available to the user.  MODE will be set
%   to 'any' or 'fixed'.
%
%   See also CGOPTIMOPTIONS/SETCONSTRAINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:39 $

mode = obj.constraints.mode;