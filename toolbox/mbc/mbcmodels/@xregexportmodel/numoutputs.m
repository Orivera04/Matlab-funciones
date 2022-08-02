function out = numoutputs(E)
% exportmodel / numoutputs
% Some exportmodel classes can have multiple outputs so this method 
% returns the number of outputs. This should be overloaded
% if a child has more than one output.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:37 $

out = 1;