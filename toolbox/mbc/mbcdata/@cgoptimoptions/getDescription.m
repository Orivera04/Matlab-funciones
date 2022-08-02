function desc = getDescription(obj)
%GETDESCRIPTION Get the current description for the optimization function.
%   DESC = GETDESCRIPTION(OPTIONS) returns the description, DESC, of the
%   user-defined optimization function.
%
%   See also CGOPTIMOPTIONS/SETDESCRIPTION.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:40 $

desc = obj.description;