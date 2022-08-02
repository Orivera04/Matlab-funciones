function name = getName(obj)
%GETNAME Get the current name label for the optimization function.
%   NAME = GETNAME(OPTIONS) returns the current name label, NAME, for the
%   user-defined optimization function.
%
%   See also CGOPTIMOPTIONS/SETNAME.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:46 $

name = obj.name;