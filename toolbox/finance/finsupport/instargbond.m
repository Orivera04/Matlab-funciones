function [CouponRate, Settle, Maturity, Period, Basis, EOM, Issue, FirstCoupon, LastCoupon, Start, Face] = instargbond(varargin)
%INSTARGBOND Subroutine for 'Type','Bond' argument validation.  
%   This function is called at the top of processing routines.
%
%   [CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
%   FirstCouponDate, LastCouponDate, StartDate, Face] = instargbond(ArgList{:})
%
% Inputs: 
%     ArgList{:} input arguments to be dealt one-to-one to the outputs.
%
% Outputs: Outputs are conforming NINST x 1 vectors.
%   Type "help ftb" for more detail on SIA fixed income arguments.
%
%   CouponRate      - Decimal annual rate.
%   Settle          - Settlement date.
%   Maturity        - Maturity date.
%   Period          - Coupons per year. Default is 2.
%   Basis           - Day-count basis.  Default is 0 (actual/actual).
%   EndMonthRule    - End-of-month rule.  Default is 1 (in effect).
%   IssueDate       - Bond issue date.
%   FirstCouponDate - Irregular first coupon date.
%   LastCouponDate  - Irregular last coupon date.
%   StartDate       - Forward starting date of payments. (Input ignored in 2.0)
%   Face            - Face value.  Default is 100.
%   
% See also INSTBOND.

%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.8.2.2 $  $Date: 2004/04/06 01:07:09 $

%---------------------------------------------------------------------
% Content independent processing
%---------------------------------------------------------------------

% get the argument information for the cash flow instrument
[FieldList, ClassList, TypeString, SizeList, DefDataList] = instbond;
NumFields = length(FieldList);

% list of output arguments through parsing
ArgCells = cell(NumFields,1);

% Check the number of arguments, 3 to NumFields
if nargin<3,
  error('Settle and Maturity are required');
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
    error(sprintf('%s can have only %d column(s), not %d\n', ...
                  FieldList{iArg}, SizeList{iArg}(2), NumCols));
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

[CouponRate, Settle, Maturity, Period, Basis, EOM, Issue, ... 
 FirstCoupon, LastCoupon, Start, Face] = deal(ArgCells{:});

%---------------------------------------------------------------------
% Check validity of date parameters
%---------------------------------------------------------------------

% Settle and Maturity are required
if any(isnan(Settle))
  error('Settle is required for all Bond instruments')
end

if any(isnan(Maturity))
  error('Maturity is required for all Bond instruments')
end

% Settle <= Maturity
if any( Settle > Maturity )
  error('Settle must be less than or equal to Maturity for all Bonds')
end

% Rules for issue date:
% Issue <= Settle
if any( Issue > Settle )
  error('IssueDate must be less than or equal to Settle for all Bonds')
end

% Rules for first coupon date:
% <= LastCouponDate
% <= Maturity
% >= IssueDate
if any( FirstCoupon>LastCoupon )
  error('FirstCouponDate must be less than or equal to LastCouponDate')
end
if any( FirstCoupon>Maturity) 
  error('FirstCouponDate must be less than or equal to Maturity')
end
if any( FirstCoupon<Issue )
  error('FirstCouponDate must be greater than or equal to IssueDate')
end

% Rules for last coupon date
% >= FirstCouponDate
% <= Maturity
% >= IssueDate
if any( FirstCoupon>LastCoupon )
  error('LastCouponDate must be greater than or equal to FirstCouponDate')
end
if any( LastCoupon>Maturity) 
  error('LastCouponDate must be less than or equal to Maturity')
end
if any( LastCoupon<Issue )
  error('LastCouponDate must be greater than or equal to IssueDate')
end

%---------------------------------------------------------------------
% Check validity of flag arguments: Period, Basis, EOM
%---------------------------------------------------------------------

if (any(Period ~= 1 & Period ~= 2 & Period ~= 3 & Period ~= 4 & ...
          Period ~=6 & Period ~= 12 & Period ~= 0))
     error('Invalid Period value for coupon payment frequency');
end

if (any(Basis > 7))
     error('Invalid bond Basis value');
end

if (any(EOM ~= 0 & EOM ~= 1))
     error('Invalid EndMonthRule flag');
end