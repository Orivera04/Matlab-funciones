function err=stderr(m)
%xreglinear/STDERR   Standard error calculation
%   e=STDERR(m) calculates the standard error of the jth coefficient
%   relative to RMSE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:00 $

err=stderr(get(m,'currentmodel'));