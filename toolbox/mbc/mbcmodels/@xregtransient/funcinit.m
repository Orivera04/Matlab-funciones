function U=funcinit(U,fname);
%XREGTRANSIENT/FUNCINIT initialise user defined model defined by 'fname.m'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:58:50 $


U.simName= fname;
U = rename(U,fname);
U = simvars(U);
[null,U] = state0(U);
U= update(U,initial(U));