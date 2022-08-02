function [LegRate, Settle, Maturity, LegReset, Basis, Principal, LegType] = instargswap(varargin)
%INSTARGSWAP Subroutine for 'Type','Swap' argument validation.  
%   This function is called at the top of processing routines.
%
%   [LegRate, Settle, Maturity, LegReset, Basis, Principal, ...
%                LegType] = instargswap(ArgList{:})
%
%   Inputs: 
%     ArgList{:} input arguments to be dealt one-to-one to the outputs.
%
%   Outputs: 
%     Outputs are conforming NINSTx1 vectors or NINSTx2 matrices.
%
%
%     LegRate - NINSTx2 matrix, with each row defined as follows: 
%     [CouponRate Spread] or [Spread CouponRate]
%     where CouponRate is the decimal annual rate and Spread is the number 
%     of basis points over the reference rate. The first column represents
%     the receiving leg, while the second column represents the paying leg.                 
%
%     Settle - NINSTx1 vector of dates representing the settle date for 
%     each swap.
%
%     Maturity - NINSTx1 vector of dates representing the maturity date
%     for each swap.
%
%     LegReset - NINSTx2 matrix representing the reset frequency per year 
%     for each swap.  The default is [1 1].
%
%     Basis - NINSTx1 vector representing the basis used when annualizing the 
%     input forward rate tree for each instrument. Default is 0 (actual/actual).
%
%     Principal - NINSTx1 vector of the notional principal amounts. 
%     The default is 100.
%
%     LegType - NINSTx2 matrix, with each row representing an instrument, and 
%     each column indicating if the corresponding leg is fixed or floating.
%     A value of 0 represents a floating leg, and a value of 1 represents 
%     a fixed leg. Use this matrix to define how to interpret the values
%     entered in the Matrix LegRate. Default is [1,0] for each instrument.
%
%   
%   See also INSTSWAP.

%   Author(s): J. Akao, M. Reyes-Kattar 25-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.12 $    $Date: 2002/04/14 21:39:46 $

%---------------------------------------------------------------------
% Content independent processing
%---------------------------------------------------------------------

% Get the argument information for the cash flow instrument
[FieldList, ClassList, TypeString, SizeList, DefDataList] = instswap;
NumFields = length(FieldList);

% List of output arguments through parsing
ArgCells = cell(NumFields,1);

% Check the number of arguments
if nargin < 3,
  error('LegRate, Settle, and Maturity are required');
elseif nargin>NumFields
  error('Too many input arguments');
else
  EndArgs = cell(1,NumFields-nargin);
end

% Parse for type 
[ArgCells{:}] = finargparse(ClassList, varargin{:}, EndArgs{:});

% Enforce size limits if possible by transposing 
[ArgCells{:}] = finargflip(SizeList, ArgCells{:});

% Report size violations
for iArg = 1:NumFields,
  NumCols = size(ArgCells{iArg},2);
  if (NumCols > SizeList{iArg}(2))
    error(sprintf('%s can have only %d columns, not %d\n', ...
                  FieldList{iArg}, NumCols));
  end
end
      
% perform row expansion along the instruments
[ArgCells{:}] = finargsz(1,ArgCells{:});

% Fill in defaults for NaNs
for iArg = 1:NumFields,
  Ind = isnan(ArgCells{iArg});
  ArgCells{iArg}(Ind) = DefDataList{iArg};
end

%---------------------------------------------------------------------
% Content independent processing
%---------------------------------------------------------------------

[LegRate, Settle, Maturity, LegReset, Basis, Principal, LegType] = deal(ArgCells{:});

%---------------------------------------------------------------------
% Check validity of parameters
%---------------------------------------------------------------------

% LegRate, Settle and Maturity are required
if all(isnan(LegRate(:)))
  error('LegRate is required for all Swap instruments')
end

% No single row can be made of NaNs
m = isnan(LegRate);
if any(m(:,1) & m(:,2))
   error('A Spread must be entered for the floating leg')
end

if any(isnan(Settle))
  error('Settle is required for all Swap instruments')
end

if any(isnan(Maturity))
  error('Maturity is required for all Swap instruments')
end

% Settle <= Maturity
if any( Settle > Maturity )
  error('Settle must be less than or equal to Maturity for all Swaps')
end

if( any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3))
   error('Basis must have a value of 0, 1, 2, or 3')
end

% Default for LegType is [fixed float] for each instrument
if(all(isnan(LegType(:))))
   NumInst = size(LegRate,1);
   LegType = [ones(NumInst,1) zeros(NumInst,1)];
end

% The default may have been set for only some of the instruments
NaNRows = find(isnan(LegType(:,1)) & isnan(LegType(:,2)));
LegType(NaNRows,:) = [ones(length(NaNRows),1) zeros(length(NaNRows),1)];


if any(any(LegType ~= 0 & LegType ~= 1))
   error('LegType must have values of 0 or 1 in vanilla swaps')
end

% Default for LegReset is [1 1] for each instrument
if(all(isnan(LegReset(:))))
	NumInst = size(LegRate,1);
   LegReset = ones(NumInst,2);   
end

% The default may have been set for only some of the instruments
NaNRows = find(isnan(LegReset(:,1)) & isnan(LegReset(:,2)));
LegReset(NaNRows,:) = ones(length(NaNRows),2);


if any( any(LegReset ~= 1 & LegReset ~= 2 & LegReset ~= 3 & LegReset ~= 4 & LegReset ~= 6 & LegReset ~= 12))
   error('LegReset must have a value of 1, 2, 3, 4, 6, or 12')
end


