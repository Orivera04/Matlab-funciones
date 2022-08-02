function newobj=copyobj(obj,fig)
% COPYOBJ  Create a copy of an object with new parent
%
%   NEWOBJ=COPYOBJ(OBJ,FIG) creates a replica of the object
%   OBJ with new parent FIG.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:23 $

newobj=copyobj(obj.grid,fig);

return