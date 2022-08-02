function [r,ok]=regression(m)
% r=REGRESSION(m) returns the regression matrix for the model m

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:51 $

[r,ok]=regression(get(m,'currentmodel'));