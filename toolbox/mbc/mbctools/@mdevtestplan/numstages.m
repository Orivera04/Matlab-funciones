function n = numstages(T)
%NUMSTAGES Number of stages in testplan
%
%  NUMSTAGES(T) returns the numebr of stages in the testplan.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.2 $  $Date: 2004/02/09 08:08:07 $

n = length(T.DesignDev);
