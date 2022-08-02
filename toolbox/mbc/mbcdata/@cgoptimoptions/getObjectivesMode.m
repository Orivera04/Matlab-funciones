function mode = getObjectivesMode(obj)
%GETOBJECTIVESMODE Return the current usage of objective functions.
%   MODE = GETOBJECTIVESMODE(OPTIONS) returns a string describing how the
%   optimization makes objectives available to the user.  MODE will be set
%   to 'multiple', 'any' or 'fixed'.
%
%   See also CGOPTIMOPTIONS/SETOBJECTIVESMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:48 $

mode = obj.objectives.mode;