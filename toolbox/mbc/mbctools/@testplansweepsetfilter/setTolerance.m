function tssf = setTolerance(tssf, tol)
%SETTOLERANCE Set tolerance and hence re-run the cluster algorithm
%
%  TSSF = SETTOLERANCE(TSSF, TOL)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:42 $ 

if isnumeric(tol) && length(tol) == length(tssf.tolerance)
    % Ensure that the tolerances are a horizontal vector
    tssf.tolerance = tol(:)';
    %% keep clusters true to the tolerance??
    tssf = runClusterAlgorithm(tssf);
end