function [A,b] = pcalims(AssetMin, AssetMax, NumAssets)
%PCALIMS Linear inequalities for individual asset min and max allocation.
%   This function specifies the lower and upper bounds of portfolio
%   allocations in each of NASSETS available asset investments.
%
%   [A,b] = pcalims(AssetMin, AssetMax, NumAssets)  
% 
%   Inputs:
%     AssetMin, AssetMax : scalar or NASSETS long vector of minimum and
%     maximum allocations in each asset.  The entry NaN indicates no
%     constraint for that asset in that direction.  Scalar bounds are
%     applied to all the assets. 
%
%     NumAssets : (optional) number of assets NASSETS.  If not specified,
%     NumAssets is the length of AssetMin or AssetMax.
%
%   Outputs:
%     Matrix A and vector b such that A*Pwts' <= b enforces the constraints,
%     where Pwts is a 1 by NASSETS vector of asset allocations.
%
%     Alternate Usage:  If called with fewer than 2 output arguments, 
%     returns A and b concatenated together: Cons = [A, b];
%     Cons = pcalims(AssetMin, AssetMax, NumAssets)
% 
%   See also PORTOPT, PCPVAL, PCGLIMS, PCGCOMP, PORTCONS.
%

%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $   $ Date: 1998/01/30 13:45:34 $

%----------------------------------------------------------------------------
% Process arguments and defaults
% AssetMin  [NumAssets by 1]
% AssetMax  [NumAssets by 1]
% NumAssets [scalar]
%----------------------------------------------------------------------------

% change min and max values to column vectors
if nargin<1
  error('Enter at least a vector of minimum asset values')
else
  AssetMin = AssetMin(:);
end

if nargin<2,
  AssetMax = NaN;
else
  AssetMax = AssetMax(:);
end

% Get the number of assets and expand scalar arguments
if nargin<3,
  NumAssets = max( length(AssetMax), length(AssetMin) );
end

if length(AssetMin)==1,
  AssetMin = AssetMin(ones(NumAssets,1));
elseif length(AssetMin)~= NumAssets,
  error('Incompatible number of assets specified: AssetMin, AssetMax');
end

if length(AssetMax)==1,
  AssetMax = AssetMax(ones(NumAssets,1));
elseif length(AssetMax)~= NumAssets,
  error('Incompatible number of assets specified: AssetMin, AssetMax');
end


%----------------------------------------------------------------------------
% build inequalities
%----------------------------------------------------------------------------

% Build all the max/min equations
A = [eye(NumAssets); -eye(NumAssets)];
b = [AssetMax; -AssetMin];

% Remove equations which are not specified
Mask = isnan(b);
A(Mask,:) = [];
b(Mask)   = [];

%----------------------------------------------------------------------------
% Concatenation feature 
%----------------------------------------------------------------------------
if nargout<2,
  A = [A b];
end

%----------------------------------------------------------------------------
% end of function PCALIMS
%----------------------------------------------------------------------------

