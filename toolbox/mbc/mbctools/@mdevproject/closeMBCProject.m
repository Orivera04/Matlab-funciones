function CloseMBCProject(MP)
%CLOSEMBCPROJECT ensure a smooth removal of an existing project

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:03:21 $

UnregisterFile(MP);
delete(MP);
