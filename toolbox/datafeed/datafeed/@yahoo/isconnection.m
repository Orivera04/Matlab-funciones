function x = isconnection(c) 
%ISCONNECTION True if valid Yahoo connection.
%   X = ISCONNECTION(C) returns 1 if C is a valid Yahoo connection
%   and 0 otherwise.  This function is a placeholder for consistency
%   with other Datafeed Toolbox method directories.
%
%   See also YAHOO, CLOSE, FETCH, GET.

%   Author(s): C.F.Garvin, 02-25-00
%   Copyright 1999-2002 The MathWorks, Inc.
%   $Revision: 1.3 $   $Date: 2002/04/14 16:23:37 $

%Check for url field
t = struct(c);
if isfield(t,'url')
  x = 1;
else
  x = 0;
end
