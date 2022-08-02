function IVar = instadd(varargin)
%INSTADD Add types to an instrument collection variable.
%   INSTADD stores instruments of types: 'Bond', 'CashFlow', 'OptBond',
%   'Fixed', 'Float', 'Cap', 'Floor','Swap', 'OptStock', 'Barrier',
%   'Compound', 'Lookback', 'Asian'.
%   Pricing and sensitivity routines are provided for these instruments.  
%
%
%   Usage: 
%     The individual constructor functions are listed with each usage entry.
%
%   instbond   - bond instrument.
%   InstSet = instadd('Bond', CouponRate, Settle, Maturity, Period, Basis, EndMonthRule, ...
%                      IssueDate, FirstCouponDate, LastCouponDate, StartDate, Face)
%
%   instcf - arbitrary cash flow instrument.
%   InstSet = instadd('CashFlow', CFlowAmounts, CFlowDates, Settle, Basis)
%   
%   instoptbnd - bond option instrument. 
%   InstSet = instadd('OptBond', BondIndex, OptSpec, Strike, ExerciseDates, AmericanOpt)
%
%   instfixed - fixed rate note instrument.
%   InstSet = instadd('Fixed', CouponRate, Settle, Maturity, Reset, Basis, Principal) 
%
%   instfloat - floating rate note instrument.
%   InstSet = instadd('Float', Spread, Settle, Maturity, Reset, Basis, Principal)
%
%   instcap - cap instrument.
%   InstSet = instadd('Cap', Strike, Settle, Maturity, Reset, Basis, Principal) 
%
%   instfloor - floor instrument.
%   InstSet = instadd('Floor', Strike, Settle, Maturity, Reset, Basis, Principal) 
%
%   instswap - swap instrument.
%   InstSet = instadd('Swap', LegRate, Settle, Maturity, LegReset, Basis, ...
%                      Principal, LegType)
%
%   instoptstock - stock option instrument. 
%   InstSet = instadd('OptStock', OptSpec, Strike, Settle, ExerciseDates,...
%                      AmericanOpt)
%
%   instbarrier - barrier option instrument. 
%   InstSet = instadd('Barrier', OptSpec, Strike, Settle, ExerciseDates,...
%                      AmericanOpt, BarrierType, Barrier, Rebate)
%
%   instcompound - compound option instrument. 
%   InstSet = instadd('Compound', UOptSpec, UStrike, USettle, ...
%                      UExerciseDates, UAmericanOpt,COptSpec, CStrike, CSettle, ...
%                      CExerciseDates, CAmericanOpt)
%
%   instlookback - lookback option instrument. 
%   InstSet = instadd('Lookback', OptSpec, Strike, Settle, ExerciseDates,...
%                       AmericanOpt)
%
%   instasian    - asian option instrument. 
%   InstSet = instasian('Asian', OptSpec, Strike, Settle, ExerciseDates,...
%                         AmericanOpt, AvgType, AvgPrice, AvgDate)
%
%   To add instruments to an existing collection:
%    InstSet = instadd(InstSetOld, TypeString, Data1, Data2, ...)
%
%   Input:
%     Type, for example, "help instcap" for additional information on the 
%     cap instrument.
%
%     InstSetOld - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data
%     fields. The stored data field is a row vector or string for each
%     instrument. 
%
%   Output:   
%     InstSet - Instrument set variable containing the new input data.
%
%   Example: 
%     Create a portfolio with two cap instruments and a 4% bond:
%     Strike = [0.06; 0.07];
%     CouponRate = 0.04;
%     Settle = '08-Feb-2000';
%     Maturity = '15-Jan-2003';
%
%     InstSet = instadd('Cap', Strike, Settle, Maturity);
%     InstSet = instadd(InstSet, 'Bond', CouponRate, Settle, Maturity);
%     instdisp(InstSet)   
%
%
%   See also INSTBOND, INSTCF, INSTOPTBND, INSTFIXED, INSTFLOAT, INSTCAP, 
%            INSTFLOOR, INSTSWAP,INSTOPTSTOCK, INSTBARRIER, INSTCOMPOUND, 
%            INSTLOOKBACK, INSTASIAN

%   Author(s): J. Akao, M. Reyes-Kattar 10/27/99
%   Copyright 1995-2003 The MathWorks, Inc. 
%   $Revision: 1.18.2.1 $  $Date: 2003/08/29 04:45:48 $

%---------------------------------------------------------------------
% Check for an existing instrument variable and pull out the TypeString
%---------------------------------------------------------------------
if nargin<2,
  error('At least TypeString and one data argument are required')
end

Args = varargin;
if isafin(varargin{1}, 'Instruments')
  TypeString = varargin{2};
  Args(2) = [];
else
  TypeString = varargin{1};
  Args(1) = [];
end

%---------------------------------------------------------------------
% Dispatch to the proper constructor
%---------------------------------------------------------------------
switch TypeString
 case 'Bond'
  IVar =   instbond(Args{:});

 case 'CashFlow'
  IVar =     instcf(Args{:});    

 case 'OptBond'
  IVar = instoptbnd(Args{:});

 case 'Fixed'
  IVar =  instfixed(Args{:}); 

 case 'Float'
  IVar =  instfloat(Args{:}); 

 case 'Cap'
  IVar =    instcap(Args{:});   

 case 'Floor'
  IVar =  instfloor(Args{:}); 

 case 'Swap'
  IVar =   instswap(Args{:});
  
 case 'OptStock'
  IVar =   instoptstock(Args{:});
  
 case 'Barrier'
  IVar =   instbarrier(Args{:});
  
 case 'Compound'
  IVar =   instcompound(Args{:});
  
 case 'Lookback'
  IVar =   instlookback(Args{:});
  
 case 'Asian'
  IVar =   instasian(Args{:});

 otherwise
  error('Instrument type not recogized')

end

return



