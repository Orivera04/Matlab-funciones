function AccrFraction = accrfrac(varargin)
%ACCRFRAC Fraction of coupon period before settlement.
%   This function calculates the fractional portion of the coupon period
%   that has accrued as of settlement for NBONDS fixed income securities. 
%   Multiplying this fraction by the nominal periodic coupon cash flow 
%   amount yields the accrued interest payable on that bond.  The function
%   covers accrued interest for bonds with regular or odd first or last
%   coupon periods.
%
%   Fraction = accrfrac(Settle, Maturity)
%
%   Fraction = accrfrac(Settle, Maturity, Period, Basis, EndMonthRule, ...
%          IssueDate, FirstCouponDate, LastCouponDate, StartDate)
%
%   Inputs: All required inputs are NBONDS by 1 vectors or scalars.
%     Optional inputs can also be passed as empty matrices or omitted at 
%     the end of the argument list.  The value NaN in any optional input
%     invokes the default value for that entry.  Date arguments can be
%     serial date numbers or date strings.  For SIA bond argument descriptions,
%     type "help ftb".  For a detailed  description of a particular 
%     argument, for example Settle, type "help ftbSettle". 
%
%     Settle     (Required) - Settlement date.
%     Maturity   (Required) - Maturity date.
%   
%   Optional Inputs:
%     Period - Coupon frequency; default is "2" for semi-annual.
%     Basis  - Bond basis; default is "0" for Actual/Actual.
%     EndMonthRule - End of month rule; default is "1" meaning "in effect".
%     IssueDate - Date of issue and interest accrual.
%     FirstCouponDate - First actual coupon date.
%     LastCouponDate - Last actual coupon date.
%     StartDate - Starting date (Argument reserved for future implementation).
%
%   Outputs: 
%     Fraction - NBONDS x 1 vector of accrued interest fractions.
%
%   See also CFAMOUNTS, CPNDATEN, CPNDATENQ, CPNDATEP, CPNDATEPQ, CPNDAYSN, 
%            CPNDAYSP, CPNPERSZ, CPNCOUNT, CFDATES.
 
%Author(s): C. Bassignani, 04-04-98, 07-31-98 
%   Copyright 1995-2003 The MathWorks, Inc.
%$Revision: 1.15.2.2 $   $Date: 2004/04/06 01:06:18 $ 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GET/PARSE INPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Checking the input arguments and set defaults
if (nargin < 2) 
  error('You must enter at least Settle and Maturity');
end 

% There are no default values for settle or maturity.
% Check to see if either or both settle and maturity are empty; if so set
% the output matrices to empties and return
if (isempty(varargin{1}) | isempty(varargin{2}))
  AccrFraction = [];
  return
end

[CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, IssueDate, ...
 FirstCouponDate, LastCouponDate, StartDate] = ...
    instargbond(0, varargin{:});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                   ************* GENERATE OUTPUT(S) **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Preallocate all variables
TempFraction = zeros(size(Settle));

%Find all zero coupon bonds and set the frequency to "2"
ZeroCouponBondInd = find(Period == 0);

Period(ZeroCouponBondInd) = 2;

Basis2 = Basis;
Basis2(find(Basis2==4 | Basis2==5 | Basis2==6)) = 1;
Basis2(find(Basis2==7)) = 3;

%Get the number of days from the previous coupon date to settlement
PreviousCouponDate = cpndatep(Settle, Maturity, Period, Basis2, ...
     EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate);

DaysLastDate = daysdif(PreviousCouponDate, Settle, Basis);

%Get the number of days in the coupon period that contains the settlement
%date
DaysPeriod = cpnpersz(Settle, Maturity, Period, Basis, EndMonthRule,...
     IssueDate, FirstCouponDate, LastCouponDate, StartDate);

%Calculate accrued interest on all bonds which have a frequency other than
%zero (i.e. all non-zero coupon bonds)
Ind = find(DaysPeriod ~= 0);
if (~isempty(Ind))
     TempFraction(Ind) = DaysLastDate(Ind) ./ DaysPeriod(Ind);
end

%Calculate accrued interest in the case where there is a long first coupon
%period (see: Securities Industry Association. Standard Securities
%Calculation Methods. New York: SIA Publications. 1994. pp. 21 - 27.) 

WorkInd = find(~isnan(IssueDate) & ~isnan(FirstCouponDate) &...
     FirstCouponDate > Settle);
     
if (~isempty(WorkInd))
          
     PreviousIssueDate = nan.* ones(size(Settle));
     
     PreviousFirstCouponDate = PreviousIssueDate;
        
     PreviousIssueDate(WorkInd) = datemnth(IssueDate(WorkInd),...
          -12, 0, Basis(WorkInd), EndMonthRule(WorkInd));
          
     CashFlowDates = cfdates(PreviousIssueDate(WorkInd),...
          Maturity(WorkInd), Period(WorkInd), Basis2(WorkInd), ...
          EndMonthRule(WorkInd), [], [], FirstCouponDate(WorkInd));
          
     WholePeriods = nan .* ones(size(Settle));
          
     NumBonds = size(Settle, 1);
          
     for (i = 1 : length(WorkInd))
                       
          %Get the number of whole quasi periods between the quasi coupon
          %period containing issue date and the quasi period containing
          %settle (these may be the same quasi period)
          %WholePeriods(WorkInd(i), 1) = length(find( ...
          %     (CashFlowDates(i, :) > ...
          %     IssueDate(WorkInd(i), 1)) & ...
          %     (CashFlowDates(i, :) <...
          %     Settle(WorkInd(i), 1)) )) - 1;
          WholePeriods(WorkInd(i), 1) = length(find( ...
               (CashFlowDates(i, :) >= ...
               IssueDate(WorkInd(i), 1)) & ...
               (CashFlowDates(i, :) <=...
               Settle(WorkInd(i), 1)) )) - 1;
          
          %Calculate the accrued portion of the quasi coupon date containing
          %issue date
          AftIssueInd = min(find(CashFlowDates(i, :)  >=...
               IssueDate(WorkInd(i), 1)));
               
          BefIssueInd = max(find(CashFlowDates(i, :) <...
               IssueDate(WorkInd(i), 1)));
               
          Issue2AftIssue = daysdif(IssueDate(WorkInd(i), 1), ...
               CashFlowDates(i, AftIssueInd),...
               Basis(WorkInd(i), 1));
                         
          PrevIssue2AftIssue = daysdif(...
               CashFlowDates(i, BefIssueInd), ...
               CashFlowDates(i, AftIssueInd), ...
               Basis(WorkInd(i), 1));
               
          IssueFrac = Issue2AftIssue ./ PrevIssue2AftIssue;
          
          %Find the accrued portion of the quasi coupon period containing
          %settlement
          %AftSetInd = min(find(CashFlowDates(i, :) > Settle(i, 1)));
          AftSetInd = min(find(CashFlowDates(i, :) > Settle(WorkInd(i), 1)));
               
          %BefSetInd = max(find(CashFlowDates(i, :) < ...
          %     Settle(WorkInd(i), 1)));
          BefSetInd = max(find(CashFlowDates(i, :) <= ...
               Settle(WorkInd(i), 1)));
               
          Prev2Settle = daysdif(CashFlowDates(i, BefSetInd), ...
               Settle(WorkInd(i), 1), Basis(WorkInd(i), 1));
               
          Prev2First = daysdif(CashFlowDates(i, BefSetInd),...
               CashFlowDates(i, AftSetInd), ...
               Basis(WorkInd(i), 1));
               
          SettleFrac = Prev2Settle ./ Prev2First;
               
          %Caculate the whole accrued interest fraction               
          TempFraction(WorkInd(i), 1) = IssueFrac + WholePeriods(WorkInd(i), 1) + ...
               SettleFrac;
               
     end %end of for loop
end


%Find cases where the last coupon date has been specified as a date
%preceeding settle. This can create a long first coupon period and an
%accrued interest fraction greater than 1
if (~isempty(LastCouponDate))
          
     Ind = find(LastCouponDate < Settle);
     
     if (~isempty(Ind))
          
          NextMaturity = datemnth(Maturity, 12, 0, Basis, ...
               EndMonthRule);
                    
          for (i = 1 : length(Ind))
          
               TempFraction(Ind(i)) = accrfrac(Settle(Ind(i)), ...
                    NextMaturity(Ind(i)), Period(Ind(i)), Basis(Ind(i)),...
                    EndMonthRule(Ind(i)), LastCouponDate(Ind(i)), ...
                    Maturity(Ind(i)));
               
          end %end of for loop
          
     end
     
end


%Make sure the accrued interest on a zero coupon bond is zero
TempFraction(ZeroCouponBondInd) = 0;


%Reshape output
% AccrFraction = reshape(TempFraction, RowSize, ColumnSize);
AccrFraction = TempFraction;

%end ACCRFRAC function