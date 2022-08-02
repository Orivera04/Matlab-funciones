function lock=getlock(d)
%GETLOCK  Get a lock flag from design
%
% LOCK=GETLOCK(D)  gets the lock flag from D.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:06:39 $

lock = d.lockflag;
