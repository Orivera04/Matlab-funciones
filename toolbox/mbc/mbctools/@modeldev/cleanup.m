function mdev=cleanup(mdev)
%CLEANUP

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:04 $

mdev.Model=cleanup(mdev.Model);

pointer(mdev);