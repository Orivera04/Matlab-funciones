function [CouponRate, Settle, Maturity, FixedReset, Basis, Principal] = instargfixed(varargin)
%INSTARGFIXED Subroutine for 'Type','Fixed' argument validation.  
%   This function is called at the top of processing routines.
%
%   [CouponRate, Settle, Maturity, Reset, Basis, Principal] = instargfixed(ArgList{:})
%
%   Inputs: 
%     ArgList{:} input arguments to be dealt one-to-one to the outputs.
%
%   Outputs: 
%     Outputs are conforming NINST x 1 vectors.
%
%     CouponRate      - Decimal annual rate.
%     Settle          - Settlement date.
%     Maturity        - Maturity date.
%     Reset           - Reset frequency per year. Default is 1.
%     Basis           - Day-count basis.  Default is 0 (actual/actual).
%     Principal       - Notional principal amount. Default is 100.
%   
%   See also INSTFIXED.

%   Author(s): J. Akao, M. Reyes-Kattar 04/28/99
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 21:39:37 $

%---------------------------------------------------------------------
% Content independent processing
%---------------------------------------------------------------------

% get the argument information for the cash flow instrument
[FieldList, ClassList, TypeString, SizeList, DefDataList] = instfixed;
NumFields = length(FieldList);

% list of output arguments through parsing
ArgCells = cell(NumFields,1);

% Check the number of arguments, 3 to NumFields
if nargin<3,
  error('CouponRate, Settle, and Maturity are required');
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

[CouponRate, Settle, Maturity, FixedReset, Basis, Principal] = deal(ArgCells{:});

%---------------------------------------------------------------------
% Check validity of date parameters
%---------------------------------------------------------------------

% Settle and Maturity are required
if any(isnan(Settle))
  error('Settle is required for all Fixed Rate Note instruments')
end

if any(isnan(Maturity))
  error('Maturity is required for all Fixed Rate Note instruments')
end

% Settle <= Maturity
if any( Settle > Maturity )
  error('Settle must be less than or equal to Maturity for all Fixed Rate Notes')
end


%---------------------------------------------------------------------
% Check validity of flag arguments: FixedReset, Basis, EOM
%---------------------------------------------------------------------

if (any(FixedReset ~= 1 & FixedReset ~= 2 & FixedReset ~= 3 & FixedReset ~= 4 & ...
          FixedReset ~=6 & FixedReset ~= 12 & FixedReset ~= 0))
     error('Invalid Reset value for coupon payment frequency');
end

if (any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3))
     error('Invalid Fixed Rate Note Basis value');
end

