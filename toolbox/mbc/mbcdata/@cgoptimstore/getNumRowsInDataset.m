function num_rows = getnumrowsindataset(cgoptimstore, varargin)
%GETNUMROWSINDATASET Get the number of rows in an optimization operating
%                    point set
%
%  NPTS = GETNUMROWSINDATASET(OPTIMSTORE) returns the number of rows in the
%  'Primary' operating point set.
%
%  NPTS = GETNUMROWSINDATASET(OPTIMSTORE, DATASETNAME) returns the number
%  of rows in the operating point set labelled DATASETNAME.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:24 $
    
num_rows = getnumrowsoppoint(cgoptimstore.cgoptim, varargin{:});
   
