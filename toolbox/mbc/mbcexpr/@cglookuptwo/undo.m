function LT=undo(LT,n,varargin);
%UNDO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:43 $

% Will reset the table to the nth model. 

M = LT.Memory{n}.Values;
LT = setvalues(LT,M,varargin);
