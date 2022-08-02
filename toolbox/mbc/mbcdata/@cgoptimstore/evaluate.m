function [y, ysums] = evaluate(optimstore, X, varargin)
%EVALUATE Evaluate optimization objectives and constraints.
%   Y = EVALUATE(OPTIMSTORE, X) evaluates all of the optimization
%   objectives and constraints at the free variable values X.  X must be a
%   (NPoints-by-NFreeVar) matrix where NPoints is the number of points in
%   the Primary data set and NFreeVar is the number of free variables in
%   the optimization.  The operating points used for evaluation are those
%   in the Primary data set.
%
%   Y = EVALUATE(OPTIMSTORE, X, ITEMNAMES) evaluates the objectives and
%   constraints specified in the cell array of strings, ITEMNAMES, at the
%   free variable values X.  The values of the objectives and constraints
%   are returned in Y, which is of size (NPoints-by-NItems) where NItems is
%   the number of objectives and constraints listed in ITEMNAMES.
%
%   Y = EVALUATE(OPTIMSTORE, X, ITEMNAMES, DATASETNAME) evaluates the
%   specified objectives and constraints at the operating points in the
%   data set specified by the string DATASETNAME.
%
%   Y = EVALUATE(OPTIMSTORE, X, ITEMNAMES, DATASETNAME, ROWIND) evaluates
%   the specified objectives and constraints at the points of DATASETNAME
%   given by ROWIND. X must be a (NRows-by-NFreeVar) matrix where NRows is
%   the length of ROWIND. ROWIND must be a list of integer indicies in the
%   range [1 NumRowsInDataset].  Y is a (Nrows-by-NItems) matrix.
%
%   See also CGOPTIMSTORE/GRIDEVALUATE, CGOPTIMSTORE/PEVEVALUATE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:54:20 $ 

% Default is now concat eval
[y, ysums] = eval(optimstore.cgoptim, 'eval', X , varargin{:});


