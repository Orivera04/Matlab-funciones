function [A,b] = pcpval(PortValue, NumAssets)
%PCPVAL Linear inequalities for fixing total portfolio value.
%   This function scales the total value of a portfolio of NumAssets assets 
%   to PortValue.  All portfolio weights, bounds, return, and risk values 
%   except ExpReturn and ExpCovariance (see PORTOPT) are in terms of PortValue.  
%  
%   [A,b] = pcpval(PortValue, NumAssets)
%
%   Inputs:
%     PortValue : Total value of asset portfolio (scalar).  PortValue is the
%     sum of the allocations in all the assets.  Use PortValue = 1 to specify
%     weights as fractions of the portfolio and return and risk numbers as
%     rates instead of value.
%
%     NumAssets : Number of available asset investments.
%
%   Outputs:
%     Matrix A and vector b such that A*Pwts' <= b sets the value,
%     where Pwts is a 1 by NumAssets vector of asset allocations.
%
%     Alternate Usage:  If called with fewer than 2 output arguments, 
%     returns A and b concatenated together: Cons = [A, b];
%     Cons = pcpval(PortValue, NumAssets)
% 
%   See also PORTOPT, PCALIMS, PCGLIMS, PCGCOMP, PORTCONS.

%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $   $ Date: 1998/01/30 13:45:34 $

%----------------------------------------------------------------------------
% Process arguments and defaults
% PortValue [scalar]
% NumAssets [scalar]
%----------------------------------------------------------------------------

if nargin<2,
  error('Must specify PortValue and NumAssets');
end

%----------------------------------------------------------------------------
% build inequalities
%----------------------------------------------------------------------------

% Constrain the portfolio value from both sides
A = [ones(1,NumAssets); -ones(1,NumAssets)];
b = [PortValue; -PortValue];

%----------------------------------------------------------------------------
% Concatenation feature 
%----------------------------------------------------------------------------
if nargout<2,
  A = [A b];
end

%----------------------------------------------------------------------------
% end of function PCPVAL
%----------------------------------------------------------------------------
