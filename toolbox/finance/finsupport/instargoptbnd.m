function [OptSpec,Strike,ExerciseDates,AmericanOpt,CouponRate, Settle, Maturity, Period, Basis, EOM, Issue, FirstCoupon, LastCoupon, Start, Face] = instargoptbnd(varargin)
%INSTARGOPTBND Subroutine for 'Type','OptBond' argument validation.  
%   This function is called at the top of processing routines.
%
%   [OptSpec, Strike, ExerciseDates, AmericanOpt, ...
%   CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
%   FirstCouponDate, LastCouponDate, StartD, Face] = instargoptbnd(ArgList{:})
%
%   Inputs: 
%     ArgList{:} input arguments to be dealt one-to-one to the outputs.
%
%   Outputs: 
%     OptSpec         - NINST x 1 cell strings 'call' or 'put'
%     Strike          - NINST x NSTRIKES strike price values
%     ExerciseDates   - NINST x NSTRIKES or NINST x 2 exercise dates
%     AmericanOpt     - NINST x 1 flags 0 or 1
%     CouponRate      - Decimal annual rate.
%     Settle          - Settlement date.
%     Maturity        - Maturity date.
%     Period          - Coupons per year. Default is 2.
%     Basis           - Day-count basis.  Default is 0 (actual/actual).
%     EndMonthRule    - End-of-month rule.  Default is 1 (in effect).
%     IssueDate       - Bond issue date.
%     FirstCouponDate - Irregular first coupon date.
%     LastCouponDate  - Irregular last coupon date.
%     StartDate       - Forward starting date of payments. (Input ignored)
%     Face            - Face value.  Default is 100.
%   
%   See also INSTBOND, INSTOPTBND.

%   Author(s): J. Akao 04-May-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:39:49 $

%---------------------------------------------------------------------
% Content independent processing
%---------------------------------------------------------------------

% Get the argument information for the option and bond instrument
[FieldListO, ClassListO, TypeStringO, SizeListO, DefDataListO] = instoptbnd;
[FieldListB, ClassListB, TypeStringB, SizeListB, DefDataListB] = instbond;

% Throw away the optbnd UnderInd field and catenate the arguments
FieldList = [FieldListO(2:end); FieldListB];
ClassList = [ClassListO(2:end); ClassListB];
SizeList  = [SizeListO(2:end); SizeListB];
DefDataList = [DefDataListO(2:end); DefDataListB];
NumFields = length(FieldList);

% list of output arguments through parsing
ArgCells = cell(NumFields,1);

% Check the number of arguments, 3 to NumFields
if nargin<7,
  error('At least 7 arguments are required for an option bond');
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
for iArg = 4:NumFields,
  Ind = isnan(ArgCells{iArg});
  ArgCells{iArg}(Ind) = DefDataList{iArg};
end

%---------------------------------------------------------------------
% Content independent processing done
%---------------------------------------------------------------------

[OptSpec,Strike,ExerciseDates,AmericanOpt,...
 CouponRate, Settle, Maturity, Period, Basis, EOM, Issue, ... 
 FirstCoupon, LastCoupon, Start, Face] = deal(ArgCells{:});

%---------------------------------------------------------------------
% Handle strike schedule sizes
%---------------------------------------------------------------------
AmericanOpt = logical(AmericanOpt);

AmericanInd = find(AmericanOpt);
EuropeanInd = find(~AmericanOpt);

% American Option:
% Strike should be a single number, one or two dates in Exercise
if ~isempty(AmericanInd)
  StrikeA = Strike(AmericanInd,:);
  ExerciseA = ExerciseDates(AmericanInd,:);
  
  % collect the non-Nan's in the front
  [StrikeA,   NSperRow] = finargpack(1, StrikeA);
  [ExerciseA, NDperRow] = finargpack(1, ExerciseA);
  
  % There should be a single strike value
  NS = size(StrikeA,2);
  if any(NSperRow == 0)
    error('Every option must have a strike value');
  elseif any(~all((StrikeA(:,ones(1,NS))==StrikeA) | isnan(StrikeA),2));
    error('Each American exercise option can have only 1 strike value')
  end
  StrikeA = StrikeA(:,1);
  
  % There must be 1 or 2 dates in ExerciseDates
  if any(NDperRow == 0)
    error('Every option must have an exercise date')
  elseif any(NDperRow>2)
    error(['Each American option can have only a starting and ending' ...
           ' ExerciseDate']);
  end
  
  % Add default starting date of Settle
  ND = size(ExerciseA);
  if ND==1
    ExerciseA = [Settle(AmericanInd), ExerciseA];
  else
    ExerciseA(NDperRow==1,2) = Settle(AmericanInd(NDperRow==1));
  end
  
  % Make the first date the start and the last date the end
  Ind = ( ExerciseA(:,1) > ExerciseA(:,2) );
  S = ExerciseA(Ind,1);
  ExerciseA(Ind,1) = ExerciseA(Ind,2);
  ExerciseA(Ind,2) = S;
  
else
  StrikeA = [];
  ExerciseA = [];
end

% European/Bermudan option
% Strikes should be expanded over all the exercise dates
if ~isempty(EuropeanInd)
  StrikeE = Strike(EuropeanInd,:);
  ExerciseE = ExerciseDates(EuropeanInd,:);
  
  % collect the non-Nan's in the front and pad strike columns
  [ExerciseE, NDperRow] = finargpack(1, ExerciseE);
  [StrikeE,   NSperRow] = finargpack(1, StrikeE);
  StrikeE = finargpad(2, StrikeE, ExerciseE);

  if any(NSperRow > NDperRow)
    error('A Bermuda option cannot have more strikes than exercise dates');
  elseif any( (NDperRow > NSperRow) & (NSperRow ~= 1) )
    error('A Bermuda option must have a strike for each exercise dates');
  end
  
  % scalar expand strikes to all exercise dates
  Ind = find(NDperRow > NSperRow);
  for k = Ind(:)'
    StrikeE(k,1:NDperRow(k)) = StrikeE(k,1);
  end
  
  % ensure that the dates are in increasing order
  Ind = find( any( diff(ExerciseE,[],2) < 0 , 2 ) );
  for k = Ind(:)'
    [ExerciseE(k, 1:NDperRow(k)), I] = sort( ExerciseE(k,1:NDperRow(k)) );
    StrikeE(k, 1:NDperRow(k)) = StrikeE(k, I);
  end
     
else
  StrikeE = [];
  ExerciseE = [];
end
  
% Catenate the American and European sets and then reorder
Strike = finargcat(1, StrikeE, StrikeA);
ExerciseDates = finargcat(1, ExerciseE, ExerciseA);
  
Strike([EuropeanInd; AmericanInd],:) = Strike;
ExerciseDates([EuropeanInd; AmericanInd],:) = ExerciseDates;

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

if (any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3))
     error('Invalid bond Basis value');
end

if (any(EOM ~= 0 & EOM ~= 1))
     error('Invalid EndMonthRule flag');
end

%--------------------------------------------------------------------
% Check string arguments
%--------------------------------------------------------------------
OptSpec = cellstr( lower(OptSpec) );
CallMatch = strcmp(OptSpec, 'call');
PutMatch  = strcmp(OptSpec, 'put');

Ind = find(~(CallMatch | PutMatch));
if any(Ind)
  BadOpt = unique(OptSpec(Ind,:), 'rows')';
  BadOpt = finargcat(1,BadOpt,' ');
  error(['Unrecognized OptSpec: ',BadOpt(:)'])
end

%--------------------------------------------------------------------
% All option dates must be before Maturity
%--------------------------------------------------------------------
ND = size(ExerciseDates,2);
if any(any( ExerciseDates > Maturity(:,ones(1,ND)) ))
  error('All exercise dates must fall before or on bond Maturity')
end
