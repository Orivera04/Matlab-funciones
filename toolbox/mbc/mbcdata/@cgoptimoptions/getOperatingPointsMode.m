function mode = getOperatingPointsMode(obj)
%GETOPERATINGPOINTSMODE Return the current usage of operating point sets.
%   MODE = GETOPERATINGPOINTSMODE(OPTIONS) returns a string describing how
%   the optimization makes operating point sets available to the user.
%   MODE will be set to 'default', 'fixed' or 'any'.
%
%   See also CGOPTIMOPTIONS/SETOPERATINGPOINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:50 $

mode = obj.operatingpoints.mode;

