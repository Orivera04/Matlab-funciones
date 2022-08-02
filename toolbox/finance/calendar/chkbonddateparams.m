function [Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
          FirstCouponDate, LastCouponDate, StartDate, varargout] = ...
          chkbonddateparams( ...
          Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
          FirstCouponDate, LastCouponDate, StartDate, varargin)
%CHKBONDDATEPARAMS Bond Parameter Checking and Default Setting
%   Checks for size consistency among all the inputs and performs
%   scalar expansion so that all the outputs are the same size.
%   For date parameters, also sets defaults if [] is passed in, 
%   checks argument validity, and converts to serial date number.
% 
%      [Settle, Maturity, Period, Basis, EndMonthRule, IssueDate,
%       FirstCouponDate, LastCouponDate, StartDate, P1, P2, ...]=
%       chkbonddateparams(Settle, Maturity, Period, Basis,
%       EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate,
%       StartDate, P1in, P2in, ... ) 
%
%   Inputs should be scalar, empty, or conforming vectors (possibly
%   containing NaN's).  Outputs are empty or conforming column vectors.
%
%    Date Arguments and defaults 
%      Settle            none
%      Maturity          none
%      Period            2
%      Basis             0
%      EndMonthRule      1
%      IssueDate         []
%      FirstCouponDate   []
%      LastCouponDate    []
%      StartDate         []   
%
%
%   See also SCALEUPVARG.

%Author(s): C. Bassignani, 03-30-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.9 $   $Date: 2002/04/14 21:48:53 $ 


%Checking the input arguments and set defaults
if (isempty(Period))
  Period = 2;
end

if (isempty(Basis))
  Basis = 0;
end

if (isempty(EndMonthRule))
  EndMonthRule = 1;
end

if (isempty(IssueDate))
     IssueDate = NaN;
end
     
if (isempty(FirstCouponDate))
     FirstCouponDate = NaN;
end

if (isempty(LastCouponDate))
     LastCouponDate = NaN;
end

if (isempty(StartDate))
     StartDate = NaN;
end


%Convert date strings to serial date numbers where necessary
if (ischar(Settle))
     Settle = datenum(Settle);
end

if (ischar(Maturity))
     Maturity = datenum(Maturity);
end

if ((ischar(IssueDate)))
     IssueDate = datenum(IssueDate);
end

if ((ischar(FirstCouponDate)))
     FirstCouponDate = datenum(FirstCouponDate);
end

if ((ischar(LastCouponDate)))
     LastCouponDate = datenum(LastCouponDate);
end

if ((ischar(StartDate)))
     StartDate = datenum(StartDate);
end


% Do scalar expansion as necessary and check for size conformity among all 
% inputs.  Pass non-date parameters through
NumDateParams = 9;
if nargout > NumDateParams
  varargout = cell(1, nargout-NumDateParams);
  [Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
        FirstCouponDate, LastCouponDate, StartDate, varargout{:}] = ...
      scaleupvarg( ...
      Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
      FirstCouponDate, LastCouponDate, StartDate, varargin{:});
else
  varargout = cell(1, 0);
  [Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
        FirstCouponDate, LastCouponDate, StartDate] = ...
      scaleupvarg( ...
      Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
      FirstCouponDate, LastCouponDate, StartDate, varargin{:});
end

%Check for valid input arguments
if (any(Period ~= 1 & Period ~= 2 & Period ~= 3 & Period ~= 4 & ...
          Period ~=6 & Period ~= 12 & Period ~= 0))
     error('Invalid coupon payment frequency specified!');
end

if (any(Basis ~= 0 & Basis ~= 1 & Basis ~= 2 & Basis ~= 3))
     error('Invalid bond basis specified!');
end

if (any(EndMonthRule ~= 0 & EndMonthRule ~= 1))
     error('Invalid end of month rule flag specified!');
end

%-----------------------------------------------------------------------------
%Check validity of date parameters

%Rules for settlement and maturity date:
%1. =< Maturity
Ind = find(Settle > Maturity);
if (~isempty(Ind))
     error('Settlement must be less than or equal to maturity for all bonds!');
end

%Rules for issue date:
%1. <= Settle
Ind = find(IssueDate > Settle);
if (~isempty(Ind))
     error('Issue date must precede settle for all bonds!');
end

%Rules for first coupon date:
%1. <= LastCouponDate
%2. >= IssueDate
%3. <= Maturity
Ind = find(FirstCouponDate > LastCouponDate | FirstCouponDate < IssueDate |...
     FirstCouponDate > Maturity);
if (~isempty(Ind))
     error('First coupon date must be greater than or equal to issue date and last coupon date and less than maturity for all bonds!')
end

%Rules for last coupon date
%1. >= FirstCouponDate
%2. >= IssueDate
%3. <= Maturity
Ind = find(LastCouponDate < FirstCouponDate | LastCouponDate < IssueDate |...
     LastCouponDate > Maturity);
if (~isempty(Ind))
     error('Last coupon date must greater than or equal to issue date and first coupon date and less than maturity for all bonds!');
end

%Rules for start date
%1. >= IssueDate
%2. <= Maturity
Ind = find(StartDate < IssueDate | StartDate > Maturity);
if (~isempty(Ind))
     error('Start date must be greater than issue date and less than maturity for all bonds!');
end

