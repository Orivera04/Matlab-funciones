function out = i_eval(SF)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(F)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:44 $


eq = SF.eqexpr;
out = eq.i_eval;