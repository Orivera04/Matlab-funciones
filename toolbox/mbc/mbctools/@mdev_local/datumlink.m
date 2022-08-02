function pdatum= datumlink(mdev)
%DATUMLINK

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:04:25 $

% link to other Datum
prnt = Parent(mdev);
pdatum= prnt.dataptr('Data');

