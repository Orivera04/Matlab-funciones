function data = getparetoweights(optim)
%GETPARETOWEIGHTS Return weights data for weighted pareto solution
%
%  DATA = GETPARETOWEIGHTS(OPTIM) returns the weights matrix that is used
%  to generate the weighted pareto solution.  DATA is a matrix with the
%  same number of rows as there are operating points and the same number of
%  columns as there are objectives.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:26 $ 

data = optim.outputWeights;