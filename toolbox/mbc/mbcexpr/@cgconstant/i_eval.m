function out = i_eval(c)
%I_EVAL Evaluate expression
%
%  OUT = I_EVAL(C)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:15 $

out = resolve(c.prec, i_eval(c.cgvalue));