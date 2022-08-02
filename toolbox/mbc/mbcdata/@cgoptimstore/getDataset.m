function dataset = getdataset(cgoptimstore, factorname, varargin)
%GETDATASET Get values from optimization operating point sets
%
%  V = GETDATASET(OPTIMSTORE, FACTORNAMES) returns data from the 'Primary'
%  operating point set. This function can only be used to return data
%  columns that are required to be in the 'Primary' operating point set.
%  FACTORNAMES is a cell array of labels specifying which columns of data
%  are to be returned from the 'Primary' data set. FACTORNAMES must only
%  include those strings used to label the required columns in the
%  'Primary' data set. These labels must be created in the 'Options'
%  section of the user defined script (these labels will have been set via
%  the CGOPTIMOPTIONS/ADDOPERATINGPOINTSET command). 
%  
%  V = GETDATASET(OPTIMSTORE, FACTORNAMES, DATASETNAME) returns data from
%  the operating point set labelled DATASETNAME in the optimization. V is a
%  NPTS by LENGTH(FACTORNAMES) matrix, where NPTS is the number of rows in
%  the operating point set labelled DATASETNAME.
%  
%  Example:
%  V = getdataset(optimstore, {'speed', 'afr'}, 'myDS') returns a NPTS by 2
%  matrix, V. NPTS is the number of rows in the operating point set
%  labelled 'myDS', V(:, 1) is the data for the variable labelled 'speed',
%  V(:, 2) is the data for the variable labelled 'afr'.
%
%  See also CGOPTIMOPTIONS/ADDOPERATINGPOINTSET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/02/09 06:54:22 $

dataset = getOppoint(cgoptimstore.cgoptim, factorname, varargin{:});
   
