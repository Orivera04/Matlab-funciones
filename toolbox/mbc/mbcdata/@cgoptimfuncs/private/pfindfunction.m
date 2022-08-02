function found = pfindfunction(fcn)
%PFINDFUNCTION Try to find a function on MATLAB's path
%
%  FOUND = PFINDFUNCTION(FCN) returns true if FCN is found on MATLAB's
%  search path.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:54:01 $ 

ex = exist(fcn);
found = (ex==2) || (ex==6);