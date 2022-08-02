function gridOK = getSwitchGrid(m, varargin)
%GETSWITCHGRID Generate a logical grid of valid sites 
%
%  GRID = GETSWITCHGRID(M, X1, X2, ..., Xn) where X1...Xn are vectors of
%  input values for each input factor returns a logical grid of size
%  (length(X1)-by-length(X2)-by-...-by-length(Xn)) that contains true
%  values at the positions where there is a valid evaluation point.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:47:22 $ 

dims = cellfun('length', varargin);
gridOK = true(dims);