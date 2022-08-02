function mode = getFreeVariablesMode(obj)
%GETFREEVARIABLESMODE Return the current usage of free variables.
%   MODE = GETFREEVARIABLESMODE(OPTIONS) returns a string describing how
%   the optimization makes free variables available to the user.  MODE will
%   be set to 'any' or 'fixed'.
%
%   See also CGOPTIMOPTIONS/SETFREEVARIABLESMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:43 $

mode = obj.freevariables.mode;