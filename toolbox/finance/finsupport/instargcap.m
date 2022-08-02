function [Strike, Settle, Maturity, CapReset, Basis, Principal] = instargcap(varargin)
%INSTARGCAP Subroutine for 'Type','Cap' argument validation.  
%   This function is called at the top of processing routines.
%
%   [Strike, Settle, Maturity, Reset, Basis, Principal] = instargcap(ArgList{:})
%
%   Inputs: 
%     ArgList{:} input arguments to be dealt one-to-one to the outputs.
%
%   Outputs: 
%     Outputs are conforming NINST x 1 vectors.
%
%     Strike     - Rate at which the cap is exercised, as a decimal number. 
%     Settle     - Settlement date.
%     Maturity   - Maturity date.
%     Reset      - Reset frequency per year. Default is 1.
%     Basis      - Day-count basis.  Default is 0 (actual/actual).
%     Principal  - Notional principal amount. Default is 100.
%   
%   See also INSTCAP.

%   Author(s): J. Akao, M. Reyes-Kattar 19-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.10 $  $Date: 2002/04/14 21:39:31 $

%---------------------------------------------------------------------
% Content independent processing
%---------------------------------------------------------------------

% get the argument information for the cash flow instrument
[FieldList, ClassList, TypeString, SizeList, DefDataList] = instcap;
NumFields = length(FieldList);

% list of output arguments through parsing
ArgCells = cell(NumFields,1);

% Check the number of arguments
if nargin<3,
  error('Strike, Settle, and Maturity are required');
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

[Strike, Settle, Maturity, CapReset, Basis, Principal] = deal(ArgCells{:});

%---------------------------------------------------------------------
% Check validity of parameters
%---------------------------------------------------------------------

% Strike, Settle and Maturity are required
if any(isnan(Strike))
  error('Strike is required for all Cap instruments')
end

if any(isnan(Settle))
  error('Settle is required for all Cap instruments')
end

if any(isnan(Maturity))
  error('Maturity is required for all Cap instruments')
end

% Settle <= Maturity
if any( Settle > Maturity )
  error('Settle must be less than or equal to Maturity for all Caps')
end

if( any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3))
   error('Basis must have a value of 0, 1, 2, or 3')
end

if( any(CapReset ~= 1 & CapReset ~= 2 & CapReset ~= 3 & CapReset ~= 4 & CapReset ~= 6 & CapReset ~= 12))
   error('Reset must have a value of 1, 2, 3, 4, 6, or 12')
end

if(any(Strike < 0 | Strike >= 1) )
   error('Invalid value for Strike');
end

