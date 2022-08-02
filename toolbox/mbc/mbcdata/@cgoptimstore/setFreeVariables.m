function optimstore = setfreevariables(optimstore, data)
%SETFREEVARIABLES Set the optimal values of the free variables
%
%  OUT = SETFREEVARIABLES(OPTIMSTORE, RESULTS) sets the optimal values of
%  the free variables, as returned by the optimization, into the
%  OPTIMSTORE. RESULTS is a NPTS by NFREEVAR matrix containing the optimal
%  values of the free variables. NPTS is the number of rows in the
%  'Primary' operating point set and NFREEVAR is the number of free
%  variables. 
% 
%  IMPORTANT NOTE : This function MUST be called at the end of the
%  optimization for the optimal values to be stored.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:30 $

optimstore.cgoptim = setfreevariables(optimstore.cgoptim, data);
