function tol= getTolerance(m);
%GETTOLERANCE Return matching tolerance of switch model
%
%  TOL = GETTOLERANCE(M) returns a vector the same length as the number of
%  switching factors, containing the matching tolerance for each factor.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:53:44 $

tol = m.Tolerance;
