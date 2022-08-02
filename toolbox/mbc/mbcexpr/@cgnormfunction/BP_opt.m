function [LT, cost, OK, msg, varargout] = BP_opt(LT,om, sf)
%BP_OPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:22 $

% [LT, varargout] = BP_OPT(LT,sf)
% adapted from mfiles/BreakpointAnalysis/Optimisation/BP_LUoptone to be an object method
% initiates optimisation routine for the breakpoints feeding into a normfunction object. The arguments are:
%
% If nargout>2, then varargout contains the spline data that we develop. 
%
%   The method proceeds as follows: firstly evaluate the model over the chosen grid and then use this grid and graph
% to generate a spline approximation to the graph. To determine whether the current choice of breakpoints is any 
% good we need to create a lookup table based on the new breakpoints that approximates the model. To do this evaluate 
% the spline at the new breakpoint positions and use the resulting matrix as the values matrix in the lookup table.
% The optimising function then evaluates the lookup table over the chosen grid and subtracts this from the model values
% at these values seeking to minimise the difference.
%

Norm = LT.Xexpr;% get the normaliser

[Norm.info, cost, OK, msg, V, Xk] = BP_opt(Norm.info,om,sf);

if nargout >3
   varargout{1} = V;
   varargout{2} = Xk;
end   
