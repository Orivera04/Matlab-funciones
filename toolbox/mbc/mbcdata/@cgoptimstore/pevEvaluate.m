function y = pevevaluate(optimstore, X, varargin)
%PEVEVALUATE Evaluates prediction error variance (PEV)
%
%  Y = PEVEVALUATE(OPTIMSTORE, X) evaluates PEV for optimization
%  objectives/constraints at the free variable values X. X must be a NPTS
%  by NFREEVAR matrix where NPTS is the number of points in the 'Primary'
%  data set and  NFREEVAR is the number of free variables. Note that the
%  operating points used for evaluation are those in the 'Primary' data
%  set. For any objectives/constraints that do not support PEV, NaN is
%  returned.
%
%  Y = PEVEVALUATE(OPTIMSTORE, X, OBJCONNAME) evaluates PEV for
%  objectives/constraints specified in the cell array of strings,
%  OBJCONNAME, at the free variable values X.  The values of the
%  objectives/constraints are returned in Y, which is of size NPTS by
%  LENGTH(OBJCONNAME).
%
%  Y = PEVEVALUATE(OPTIMSTORE, X, OBJCONNAME, DATASETNAME) evaluates PEV
%  for the objectives/constraints at the operating points in the data set
%  specified by the string DATASETNAME.
%
%  Y = PEVEVALUATE(OPTIMSTORE, X, OBJCONNAME, DATASETNAME, ROWIND)
%  evaluates PEV for the specified objectives/constraints at the points of
%  DATASETNAME given by ROWIND. X must be a LENGTH(ROWIND) by NFREEVAR
%  matrix. Y is a LENGTH(ROWIND) by LENGTH(OBJCONNAME) matrix.
%
%  See also GRIDPEVEVALUATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:54:29 $ 

% Default is now concat eval
y = eval(optimstore.cgoptim, 'pev', X , varargin{:});


