function L= update(L,param,dat)
% USERLOCAL/UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:08 $

L.userdefined= update(L.userdefined,param);

if nargin>2 & ~isempty(dat)
   L= datum(L,dat);
end