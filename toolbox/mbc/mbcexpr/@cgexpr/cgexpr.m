function e = cgexpr(e)
%CGEXPR Constructor for the main Expression  object.
%
%  This is an abstract class and should not be instantiated by anything
%  except a constructor of a child class.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:27 $

if ~nargin
    e = struct('name','', ...
        'Inputs', null(xregpointer, 0), ...
        'Version',2);
end
e = class(e,'cgexpr');