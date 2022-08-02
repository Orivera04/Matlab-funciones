function IterInfo = getIterInfo(this, values, state, type)
% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:34 $

IterInfo.Cost      = state.fval;
IterInfo.FCount    = state.funccount;
IterInfo.FirstOrd  = NaN;
IterInfo.Gradient  = NaN(size(values'));
IterInfo.Iteration = state.iteration;
IterInfo.Procedure = state.procedure;
IterInfo.StepSize  = NaN;
IterInfo.Values    = values';
